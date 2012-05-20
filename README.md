DESCRIPTION:
============
Installs and configures Sensu server, client, api and dashboard components, installs and configures rabbitmq and redis for sensu.
Sensu is a monitoring framework that aims to be simple, malleable, and scalable (https://github.com/sensu/sensu).


COOKBOOK DEPENDENCIES
============
* Apt (available @ http://community.opscode.com/cookbooks/apt)
* Yum (available @ http://community.opscode.com/cookbooks/yum)
* rabbitmq (available @ http://community.opscode.com/cookbooks/rabbitmq)
* redis (available @ https://github.com/CXInc/chef-redis)
* iptables - if using firewall options (available @ http://community.opscode.com/cookbooks/iptables)


REQUIREMENTS
============

SSL Configuration
---
A databag with SSL configuration for RabbitMQ is required, details on creating the data bag can be found at https://github.com/sensu/sensu-chef/tree/master/examples/ssl


RECIPES:
========

sensu::default
---
Installs and configures sensu and dependencies, but doesn't enable or start any sensu services.

sensu::server
---
Configures and enables the sensu-server service.

sensu::client
---
Configures and enables the sensu-client service.

sensu::api
---
Configures and enables sensu-api service, optionally configures local firewall rules if the firewall attribute is set.

sensu::dashboard
---
Configures and enables sensu-dashboard service, optionally configures local firewall rules if the firewall attribute is set.

sensu::rabbitmq
---
Installs and configures RabbitMQ with sensu vhost, adds SSL support by default and optionally configures local firewall rules if the firewall attribute is set.

sensu::redis
---
Installs and configures redis and optionally configures local firewall rules if the firewall attribute is set.


EXAMPLES
=====
Example roles are provided within the examples directory and provide a good overview of a standard Sensu setup. A vagrantfile is also provided for setting up a local test instance using this cookbook. A Cheffile example is also provided for use with Librarian-chef.


ATTRIBUTES
==========

default
-------
* `default.sensu.version` - version of sensu to install if a specific version is required. No version is specified by default
* `default.sensu.plugin.version` - version of sensu plugins gem to install (defaults to "0.1.3")
* `default.sensu.directory` - directory to store sensu configs (defaults to "/etc/sensu")
* `default.sensu.log.directory` - directory to store sensu logs (defaults to "/var/log/sensu")
* `default.sensu.ssl` - whether or not SSL encryption is used by sensu & RabbitMQ (defaults to true)
* `default.sensu.sudoers` - If true, Adds sensu sudoers config to /etc/sudoers.d/sensu (defaults to false)
* `default.sensu.firewall` -If true, will configure iptables for each sensu component - requires the iptables cookbook to be installed (defaults to false)
* `default.sensu.package.unstable` - whether or not to install newer / unstable packages (defaults to false)

rabbitmq
--------
* `default.sensu.rabbitmq.host` - Host for RabbitMQ instance (defaults to "localhost")
* `default.sensu.rabbitmq.port` - Port for RabbitMQ (defaults to 5671)
* `default.sensu.rabbitmq.vhost` - vhost for RabbitMQ (defaults to "/sensu")
* `default.sensu.rabbitmq.user` - User for RabbitMQ vhost (defaults to "sensu")
* `default.sensu.rabbitmq.password` - Password for RabbitMQ vhost (defaults to "password")

redis
-----
* `default.sensu.redis.host` - (defaults to "localhost")
* `default.sensu.redis.port` - Port for redis to listen on (defaults to 6379)

api
---
* `default.sensu.api.host` - (defaults to "localhost")
* `default.sensu.api.port` - (defaults to 4567)

dashboard
---------
* `default.sensu.dashboard.host` - (defaults to "localhost")
* `default.sensu.dashboard.port` - (defaults to 8080)
* `default.sensu.dashboard.user` - (defaults to "admin")
* `default.sensu.dashboard.password` - (defaults to "secret")


SUPPORT
=======
Please visit #sensu on irc.freenode.net and we will be more than happy to help.
