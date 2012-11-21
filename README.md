## DESCRIPTION
Provides LWRP's and service recipes to install and configure
[Sensu](https://github.com/sensu/sensu/wiki), a monitoring framework.

This cookbook provides the building blocks for creating a monitoring
cookbook specific to your environment (wrapper). An example can be
found [HERE](https://github.com/portertech/chef-monitor).

## COOKBOOK DEPENDENCIES
* apt (available @ http://community.opscode.com/cookbooks/apt)
* yum (available @ http://community.opscode.com/cookbooks/yum)
* rabbitmq (available @ http://community.opscode.com/cookbooks/rabbitmq)
* redis (available @ https://github.com/miah/chef-redis)

REQUIREMENTS
============

SSL Configuration
---
A data bag with SSL configuration for RabbitMQ is required, details on creating the data bag can be found at https://github.com/sensu/sensu-chef/tree/master/examples/ssl


RECIPES
=======

sensu::default
---
Installs and configures Sensu and dependencies, but doesn't enable or start any Sensu services.

sensu::server
---
Configures and enables the Sensu server service, "sensu-server".

sensu::client
---
Configures and enables the Sensu Client service, "sensu-client".

sensu::api
---
Configures and enables the Sensu API service, "sensu-api".

sensu::dashboard
---
Configures and enables the Sensu dashboard service, "sensu-dashboard".

sensu::rabbitmq
---
Installs and configures RabbitMQ with the Sensu vhost, adds SSL support by default.

sensu::redis
---
Installs and configures Redis.


EXAMPLES
=====
Example roles are provided within the examples directory and provide a good overview of a standard Sensu setup. A vagrantfile is also provided for setting up a local test instance using this cookbook. A Cheffile example is also provided for use with Librarian-chef.


ATTRIBUTES
==========

default
-------
* `default.sensu.version` - Version of Sensu to install
* `default.sensu.plugin.version` - Version of Sensu Plugin gem to install
* `default.sensu.directory` - Directory to store Sensu configs (defaults to "/etc/sensu")
* `default.sensu.log.directory` - Directory to store Sensu logs (defaults to "/var/log/sensu")
* `default.sensu.ssl` - If true, Sensu and RabbitMQ will use SSL encryption (defaults to true)
* `default.sensu.sudoers` - If true, adds Sensu sudoers config to /etc/sudoers.d/sensu (defaults to false)
* `default.sensu.package.unstable` - If true, will allow for the installation of unstable packages (defaults to false)

rabbitmq
--------
* `default.sensu.rabbitmq.host` - Host for RabbitMQ service (defaults to "localhost")
* `default.sensu.rabbitmq.port` - Port for RabbitMQ (defaults to 5671)
* `default.sensu.rabbitmq.vhost` - Vhost for RabbitMQ (defaults to "/sensu")
* `default.sensu.rabbitmq.user` - User for RabbitMQ vhost authentication (defaults to "sensu")
* `default.sensu.rabbitmq.password` - Password for RabbitMQ vhost authentication (defaults to "password")

redis
-----
* `default.sensu.redis.host` - Host for Redis service (defaults to "localhost")
* `default.sensu.redis.port` - Port for Redis to listen on (defaults to 6379)

api
---
* `default.sensu.api.host` - Host to locate Sensu API (defaults to "localhost")
* `default.sensu.api.port` - Port for Sensu API to listen on (defaults to 4567)

dashboard
---------
* `default.sensu.dashboard.host` - Host to locate Sensu Dashboard (defaults to "localhost")
* `default.sensu.dashboard.port` - Port for Sensu Dashboard to listen on (defaults to 8080)
* `default.sensu.dashboard.user` - User for Sensu Dashboard HTTP basic authentication (defaults to "admin")
* `default.sensu.dashboard.password` - Password for Sensu Dashboard HTTP basic authentication (defaults to "secret")


SUPPORT
=======
Please visit #sensu on irc.freenode.net and we will be more than happy to help.
