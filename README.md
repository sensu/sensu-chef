DESCRIPTION
============
Installs and configures the Sensu server, client, API and dashboard components, installs and configures RabbitMQ and Redis for Sensu.
Sensu is a monitoring framework that aims to be simple, malleable, and scalable (https://github.com/sensu/sensu).


COOKBOOK DEPENDENCIES
============
* apt (available @ http://community.opscode.com/cookbooks/apt)
* yum (available @ http://community.opscode.com/cookbooks/yum)
* rabbitmq (available @ http://community.opscode.com/cookbooks/rabbitmq)
* redis (available @ https://github.com/CXInc/chef-redis)
* iptables - If using firewall options (available @ http://community.opscode.com/cookbooks/iptables)


REQUIREMENTS
============

SSL Configuration
---
A data bag with SSL configuration for RabbitMQ is required, details on creating the data bag can be found at https://github.com/sensu/sensu-chef/tree/master/examples/ssl


RECIPES
========

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
Configures and enables the Sensu API service, "sensu-api", optionally configures local firewall rules if the firewall attribute is set.

sensu::dashboard
---
Configures and enables the Sensu dashboard service, "sensu-dashboard", optionally configures local firewall rules if the firewall attribute is set.

sensu::rabbitmq
---
Installs and configures RabbitMQ with the Sensu vhost, adds SSL support by default and optionally configures local firewall rules if the firewall attribute is set.

sensu::redis
---
Installs and configures Redis and optionally configures local firewall rules if the firewall attribute is set.


EXAMPLES
=====
Example roles are provided within the examples directory and provide a good overview of a standard Sensu setup. A vagrantfile is also provided for setting up a local test instance using this cookbook. A Cheffile example is also provided for use with Librarian-chef.


ATTRIBUTES
==========

default
-------
* `default.sensu.version` - Version of Sensu to install (defaults to "0.9.5-36")
* `default.sensu.plugin.version` - Version of Sensu plugins gem to install (defaults to "0.1.3")
* `default.sensu.directory` - Directory to store Sensu configs (defaults to "/etc/sensu")
* `default.sensu.log.directory` - Directory to store Sensu logs (defaults to "/var/log/sensu")
* `default.sensu.ssl` - If true, Sensu and RabbitMQ will use SSL encryption (defaults to true)
* `default.sensu.sudoers` - If true, adds Sensu sudoers config to /etc/sudoers.d/sensu (defaults to false)
* `default.sensu.firewall` - If true, will configure iptables for each sensu component - requires the iptables cookbook to be available (defaults to false)
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
