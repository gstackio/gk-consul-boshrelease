### Features

- [Consul v1.6.1](https://github.com/hashicorp/consul/releases/tag/v1.6.1).

- Native support for [BPM](https://bosh.io/docs/bpm/bpm/).

- Proper support for day-2 operations like scale-out or scale-in, through
  `consul leave` in drain script.

- Native support for BOSH DNS health checks.

- Support for Consul UI, that can be activated on a subset of the Consul
  server nodes.

- Full support for Gossip encryption (including enabling and disabling on a
  running cluster with no downtime), TLS encryption for API, RPC & UI,
  mutual-TLS authentication for clients, and certificates rotation, including
  CAs.

- Integrates natively with BOSH DNS, as a recursor for the `*.consul` TLD
  (this domain can be configured).


### Caveats

- Poor suport for configuring local services to check. We setimate that in a
  BOSH context, you should nowadays use the mature BOSH DNS features for
  this.

- Scaling-in from 3 nodes down to 1 node implies a short downtime (10-20
  seconds) when BOSH re-configues the only remaining node.
