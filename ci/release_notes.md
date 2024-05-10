### Features

- Bump Consul to the latest version [1.18.1](https://github.com/hashicorp/consul/blob/main/CHANGELOG.md#1181-march-26-2024)

- Bump BPM to v1.2.19 in the standard deployment manifest.


### Caveats

- Poor support for configuring local services to check. Indeed, we estimate that you should favor the native BOSH DNS features for service discovery.

- Scaling-in from 3 nodes down to 1 node implies a short downtime (10-20 seconds) while BOSH re-configures the only remaining node.
