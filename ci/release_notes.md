### Features

- Bump Consul to the latest version [1.10.4](https://github.com/hashicorp/consul/blob/main/CHANGELOG.md#1104-november-11-2021)

- Bump BPM to v1.1.15 in the standard deployment manifest.


### Caveats

- Poor support for configuring local services to check. Indeed, we estimate that you should favor the native BOSH DNS features for service discovery.

- Scaling-in from 3 nodes down to 1 node implies a short downtime (10-20 seconds) while BOSH re-configures the only remaining node.
