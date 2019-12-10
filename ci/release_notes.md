### Features

- Automate version bumps with a dedicated Concourse pipeline


### Caveats

- Poor suport for configuring local services to check. We setimate that in a
  BOSH context, you should nowadays use the mature BOSH DNS features for
  this.

- Scaling-in from 3 nodes down to 1 node implies a short downtime (10-20
  seconds) when BOSH re-configues the only remaining node.
