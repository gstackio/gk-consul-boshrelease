### Features

- Bump Consul to the latest version [1.8.4](https://github.com/hashicorp/consul/blob/master/CHANGELOG.md#184-september-11-2020)

- Bump BPM to v1.1.9 in the standard deployment manifest.


### Notice

- When using `tls.ca_bundle`, the `tls.cert.ca` doesn't need to be added to the CA bundle anylore. By design here in this BOSH Release, the `tls.cert.ca` is always a trusted CA. If you were explicitely adding the `tls.cert.ca` to the `tls.ca_bundle` (because you were forced to, in order for the BOSH DNS health check to properly work), then you don't need to do this anymore. Please update your deployment manifests accordingly.


### Caveats

- Poor suport for configuring local services to check. Indeed, we estimate that you should favor the native BOSH DNS features for service discovery.

- Scaling-in from 3 nodes down to 1 node implies a short downtime (10-20 seconds) while BOSH re-configues the only remaining node.
