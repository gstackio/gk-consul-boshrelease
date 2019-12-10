### Features

- Bump Consul to the latest version [1.6.2](https://github.com/hashicorp/consul/blob/master/CHANGELOG.md#162-november-13-2019)

- Automate version bumps with a dedicated Concourse pipeline


### Caveats

- Poor suport for configuring local services to check. We setimate that in a
  BOSH context, you should nowadays use the mature BOSH DNS features for
  this.

- Scaling-in from 3 nodes down to 1 node implies a short downtime (10-20
  seconds) when BOSH re-configues the only remaining node.
