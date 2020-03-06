### Features

- Bump Consul to the latest version [1.7.1](https://github.com/hashicorp/consul/blob/master/CHANGELOG.md#171-february-20-2020)

- Bumped BPM to v1.1.7 in the standard deployment manifest.


### Caveats

- Poor suport for configuring local services to check. Indeed, we estimate that you should favor the native BOSH DNS features for service discovery.

- Scaling-in from 3 nodes down to 1 node implies a short downtime (10-20 seconds) when BOSH re-configues the only remaining node.
