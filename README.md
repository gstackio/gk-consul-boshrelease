# Consul BOSH Release

This is a modern BOSH Release for Consul, which is the fastest way to get up
and running with a cluster of [Hashicorp Consul][hashicorp_consul] when you're
using [BOSH][bosh_io].

You are provided here with all the necessary binaries, configuration
templates, and startup scripts for _converging_ Consul clusters (i.e.
installing and updating over time) on Ubuntu Bionic nodes. Plus, we also
provide here a standard [deployment manifest][depl_manifest] to help you
deploy your first Consul cluster easily.

[bosh_io]: https://bosh.io/
[hashicorp_consul]: https://www.consul.io/
[depl_manifest]: ./deploy/gk-consul.yml



## Usage

This repository includes base manifests and operator files. They can be used
for initial deployments and subsequently used for updating your deployments.

```
git clone https://github.com/gstackio/gk-consul-boshrelease.git
cd gk-consul-boshrelease/deploy

export BOSH_ENVIRONMENT=<bosh-alias>
export BOSH_DEPLOYMENT=consul
bosh deploy gk-consul.yml --vars-file=default-vars.yml
```

If your BOSH does not have Credhub/Config Server (but it should), then
remember to use `--vars-store` to allow generation of passwords and
certificates into a local YAML file.



### Update

When new versions of `gk-consul-boshrelease` are released, the
`deploy/gk-consul.yml` file is updated. This means you can easily `git pull`
and `bosh deploy` to upgrade.

```
export BOSH_ENVIRONMENT=<bosh-alias>
export BOSH_DEPLOYMENT=consul
cd gk-consul-boshrelease/deploy
git pull
bosh deploy gk-consul.yml --vars-file=default-vars.yml
```



### Clustering

Horizontal scaling works out of the box, with a mere updating of the
[`instances:` property][instances_prop] in the deployment manifest. Scaling
out to `5` nodes and then scaling in to `3` nodes again is a sandard test in
the CI pipeline.

[instances_prop]: ./deploy/gk-consul.yml#L6



## Design notes

This is a modern BOSH Release for Consul. This implies several design choices.

- Use of [BPM][bpm_doc] is mandatory.

- Recent Consul version: 1.6.1, where other BOSH Release stick to version 0.7.x
  - v0.8.4 for [Consul BOSH Release][consul_boshrelease]
  - v0.7.4 for [Consul Release][consul_release]
  - v0.7.5 for a9s Consul BOSH Release (closed source)

- About the start/drain/stop workflow:

  - Contrarily to [Consul Release][consul_release] which implements a complex
    and non-documented Confab Golang binary to manage the Consul agent state,
    we don't run into such hard-to-maintain design.

  - Just like the [Consul BOSH Release][consul_boshrelease], we chose to run
    `consul leave` (ourselves, with `leave_on_terminate: false` to disallow
    Consul to do it “auto-magically”), and adopt `rejoin_after_leave: true`.

  - Contrarily to the [Consul BOSH Release][consul_boshrelease], we chose to
    run `consul leave` at `drain` time, instead of doing it at `monit stop`
    time. We do this in order not to introduce unnecessary delays at
    `monit stop` time (which is discouraged), but at `drain` time (which is
    recommended).

  - Unfortunately, Consul has no “consul drain” command in order for the node
    to drain any client connections and possibly step down from any cluster
    leader role. Instead, we use `consul leave` which is the only available
    command that is close enough from what we need when draining a node. For
    connections to have the necessary time to be drained, we adopt a 10
    seconds delay in the `drain` script (with `leave_drain_time: "10s"`).

- About DNS-based service discovery

  - We don't allow other co-located jobs to expose `/var/vcap/jobs/*/consul`
    directories for pushing their own config about locally-checked service. On
    the contrary, the [Consul BOSH Release][consul_boshrelease] adds such
    directories as `-config-dir` arguments to the Consul agent. See also the
    (now deprecated) [Redis-Consul BOSH Release][redis_consul_boshrelease].

  - We don't implement serice definition similar to
    [`consul.services`][consul_services], allowing to specify locally-checked
    services. They are written to the ephemeral disk storage in
    `/var/vcap/data/consul/services` and this directory is added as
    `-config-dir` to the Consul agent invocation.

  - We natively interface Consul with BOSH DNS. We do this because BOSH DNS
    features have now been widely adopted in the BOSH community, and are the
    recommended way to do robust and resilient service discovery. Thus, this
    BOSH Release always registers Consul as a BOSH DNS handler. In this
    design, BOSH DNS delegates DNS requests to Consul whenever the
    Consul-reserved DNS domain (`.consul` by default) is queried.

    - This is the opposite of [Consul BOSH Release][consul_boshrelease] design
      where Consul is the primary DNS server (as overridden in
      `/etc/resolv.conf`) and then recurse to external DNS servers for queries
      unrelated to the Consul-reserved DNS domain.

    - We don't run the Consul DNS service on port `53`. We always keep it on
      the default `8600` port instead.

    - We don't provide the
      [`consul.resolvconf_override`][consul_resolvconf_override] feature to
      force the local Consul agent as the primary DNS name server to use, in
      `/etc/resolv.conf`.

- We higly support and enforce TLS encryption, with `tls.enable` defaulting to
  `true`, and mutual-TLS authentication with `tls.enforce_mutual_tls` also
  defaulting to `true`. Plus, we actively support TLS CA certificate rotation
  through the `tls.ca_bundle` property.

- We also support enabling/disabling encryption with `encrypt_verify_incoming`
  and `encrypt_verify_outgoing` through the 3-steps process described in
  [Consul documentation][enable_encrypt_existing_cluster]. Note: we haven't
  confirmed this yet, but disabling encryption temporarily might be the only
  way to rotate the encryption key, as Consul doesn't support two keys at the
  same time.

- We use the recommended `8501` port for HTTPS API on Consul servers. The
  older [Consul BOSH Release][consul_boshrelease] is re-using the HTTP port
  `8500` for this, which might create incompatibilities with toolings.

- We help the BOSH operator to set the `encrypt` key more easily. Instead of
  requiring her/him to compute a Base-64 encoded 32-bytes encryption key with
  `consul keygen` manually, we allow the BOSH operator to use a 50+
  charaters-long Credhub-generated (or BOSH CLI-generated) password, and we
  infer a 32-bytes binary key (taking care of not loosing entropy in the
  process) that we automatocally encode as Base-64 in Consul config.

[bpm_doc]: https://bosh.io/docs/bpm/bpm/
[consul_boshrelease]: https://bosh.io/releases/github.com/cloudfoundry-community/consul-boshrelease
[consul_release]: https://bosh.io/releases/github.com/cloudfoundry-incubator/consul-release
[consul_services]: https://github.com/cloudfoundry-community/consul-boshrelease/blob/master/jobs/consul/spec#L72-L73
[consul_resolvconf_override]: https://github.com/cloudfoundry-community/consul-boshrelease/blob/master/jobs/consul/spec#L36-L38
[redis_consul_boshrelease]: https://github.com/cloudfoundry-community-attic/redis-consul-boshrelease
[enable_encrypt_existing_cluster]: https://learn.hashicorp.com/consul/security-networking/agent-encryption#enable-on-an-existing-cluster



## Authors and License

Copyright © 2019-present, Benjamin Gandon, Gstack

Like the rest of BOSH, this Gstack Consul BOSH Release is released under the
terms of the [Apache 2.0 license](http://www.apache.org/licenses/LICENSE-2.0).
