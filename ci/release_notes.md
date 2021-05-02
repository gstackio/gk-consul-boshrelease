### Features

- Switch to using Bionic stemcells


### Caveats

- Poor support for configuring local services to check. Indeed, we estimate that you should favor the native BOSH DNS features for service discovery.

- Scaling-in from 3 nodes down to 1 node implies a short downtime (10-20 seconds) while BOSH re-configures the only remaining node.
