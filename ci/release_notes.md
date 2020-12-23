### Features

- Bump Consul to the latest version [1.9.1](https://github.com/hashicorp/consul/blob/master/CHANGELOG.md#191-december-11-2020) (see also the [changelog for v1.9.0](https://github.com/hashicorp/consul/blob/master/CHANGELOG.md#190-november-24-2020))


### Caveats

- Poor support for configuring local services to check. Indeed, we estimate that you should favor the native BOSH DNS features for service discovery.

- Scaling-in from 3 nodes down to 1 node implies a short downtime (10-20 seconds) while BOSH re-configures the only remaining node.
