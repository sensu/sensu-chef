## DESCRIPTION

Provides LWRP's and service recipes to install and configure
[Sensu](https://github.com/sensu/sensu/wiki), a monitoring framework.

This cookbook provides the building blocks for creating a monitoring
cookbook specific to your environment (wrapper). Without such a
wrapper, no Sensu configuration files will be created for your nodes.

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
* [Windows](http://community.opscode.com/cookbooks/windows)
* [RabbitMQ](http://community.opscode.com/cookbooks/rabbitmq)
* [RedisIO](http://community.opscode.com/cookbooks/redisio)

## REQUIREMENTS

### SSL configuration

Running Sensu with SSL is recommended; this cookbook uses a data bag
`sensu`, with an item `ssl`, containing the SSL certificates required.
Sensu data bag items may be encrypted. This cookbook comes with a tool
to generate the certificates and data bag item. If the integrity of
the certificates is ever compromised, you must regenerate and redeploy
them.

```
cd examples/ssl
./ssl_certs.sh generate
knife data bag create sensu
```

Use the plain-text data bag item:

``` shell
knife data bag from file sensu ssl.json
```

Or, encrypt it with your data bag secret. See [Encrypt a Data
Bag](https://docs.getchef.com/essentials_data_bags.html#encrypt-a-data-bag-item) for
more information.

```
knife data bag --secret-file /path/to/your/secret from file sensu ssl.json
```

``` shell
./ssl_certs.sh clean
```

## RECIPES

### sensu::default

Installs Sensu and creates a base configuration file, intended to be
extended. This recipe must be included before any of the Sensu LWRP's
can be used. This recipe does not enable or start any services.

### sensu::rabbitmq

Installs and configures RabbitMQ for Sensu, from configuring SSL to
creating a vhost and credentials. This recipe relies heavily on the
community RabbitMQ cookbook LWRP's.

### sensu::redis

Installs and configures Redis for Sensu. This recipe uses the
RedisIO cookbook and installs Redis from source.

### sensu::enterprise

Installs and configures Sensu Enterprise.

### sensu::server_service

Enables and starts the Sensu server.

### sensu::client_service

Enables and starts the Sensu client.

### sensu::api_service

Enables and starts the Sensu API.

### sensu::enterprise_service

Enables and starts Sensu Enterprise.

## ATTRIBUTES

### Installation

`node.sensu.version` - Sensu build to install.

`node.sensu.use_unstable_repo` - If the build resides on the
"unstable" repository.

`node.sensu.directory` - Sensu configuration directory.

`node.sensu.log_directory` - Sensu log directory.

`node.sensu.log_level` - Sensu log level (eg. "warn").

`node.sensu.use_ssl` - If Sensu and RabbitMQ are to use SSL.

`node.sensu.user` - The user who owns all sensu files and directories. Default
"sensu".

`node.sensu.group` - The group that owns all sensu files and directories.
Default "sensu".

`node.sensu.use_embedded_ruby` - If Sensu Ruby handlers and plugins
use the embedded Ruby in the Sensu package.

`node.sensu.init_style` - Style of init to be used when configuring
Sensu services, "sysv" and "runit" are currently supported.

`node.sensu.service_max_wait` - How long service scripts should wait
for Sensu to start/stop.

### RabbitMQ

`node.sensu.rabbitmq.host` - RabbitMQ host.

`node.sensu.rabbitmq.port` - RabbitMQ port, usually for SSL.

`node.sensu.rabbitmq.ssl` - RabbitMQ SSL configuration, DO NOT EDIT THIS.

`node.sensu.rabbitmq.vhost` - RabbitMQ vhost for Sensu.

`node.sensu.rabbitmq.user` - RabbitMQ user for Sensu.

`node.sensu.rabbitmq.password` - RabbitMQ password for Sensu.

### Redis

`node.sensu.redis.host` - Redis host.

`node.sensu.redis.port` - Redis port.

### Sensu API

`node.sensu.api.host` - Sensu API host, for other services to reach it.

`node.sensu.api.bind` - Sensu API bind address.

`node.sensu.api.port` - Sensu API port.

## LWRP'S

### Define a client

```ruby
sensu_client node.name do
  address node.ipaddress
  subscriptions node.roles + ["all"]
  additional(:cluster => node.cluster)
end
```

### Define a handler

```ruby
sensu_handler "pagerduty" do
  type "pipe"
  command "pagerduty.rb"
  severities ["ok", "critical"]
end
```

### Define a check

```ruby
sensu_check "redis_process" do
  command "check-procs.rb -p redis-server -C 1"
  handlers ["default"]
  subscribers ["redis"]
  interval 30
  additional(:notification => "Redis is not running", :occurrences => 5)
end
```

### Define a filter

```ruby
sensu_filter "environment" do
  attributes(:client => {:environment => "development"})
  negate true
end
```

### Define a mutator

```ruby
sensu_mutator "opentsdb" do
  command "opentsdb.rb"
end
```

### Define a custom configuration snippet

```ruby
sensu_snippet "irc" do
  content(:uri => "irc://sensu:password@irc.freenode.net:6667#channel")
end
```

## SUPPORT

Please visit [sensuapp.org/support](http://sensuapp.org/support) for details on community and commercial
support resources, including the official IRC channel.
