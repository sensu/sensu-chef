## DESCRIPTION

Provides LWRP's and service recipes to install and configure
[Sensu](https://github.com/sensu/sensu/wiki), a monitoring framework.

This cookbook provides the building blocks for creating a monitoring
cookbook specific to your environment (wrapper).

An example wrapper cookbook can be found
[HERE](https://github.com/portertech/chef-monitor).

[How to Write Reusable Chef Cookbooks](http://bit.ly/10r993N)

## TESTING

This cookbook comes with a Gemfile, Cheffile, and a Vagrantfile for
testing and evaluating Sensu.

```
cd examples
gem install bundler
bundle install
librarian-chef install
vagrant up
vagrant ssh
```

## COOKBOOK DEPENDENCIES

* [APT](http://community.opscode.com/cookbooks/apt)
* [YUM](http://community.opscode.com/cookbooks/yum)
* [RabbitMQ](http://community.opscode.com/cookbooks/rabbitmq)
* [Redis](https://github.com/miah/chef-redis)*

## REQUIREMENTS

### SSL CONFIGURATION

Running Sensu with SSL is recommended, this cookbook uses a data bag
`sensu`, with an item `ssl`, containing the SSL certificates required.
This cookbook comes with a tool to generate the certificates and data
bag item.

```
cd examples/ssl
./ssl_certs.sh generate
knife data bag create sensu
knife data bag from file sensu ssl.json
./ssl_certs.sh clean
```

## RECIPES

## sensu::default
Installs Sensu and creates a base configuration file, intended to be
extended. This recipe must be included before any of the Sensu LWRP's
can be used. This recipe does not enable or start any services.

## sensu::rabbitmq
Installs and configures RabbitMQ for Sensu, from configuring SSL to
creating a vhost and credentials. This recipe relies heavily on the
community RabbitMQ cookbook LWRP's.

## sensu::redis
Installs and configures Redis for Sensu.

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
