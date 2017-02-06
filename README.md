![sensu](https://raw.github.com/sensu/sensu/master/sensu-logo.png)

[![Build Status](https://img.shields.io/travis/sensu/sensu-chef.svg)](https://travis-ci.org/sensu/sensu-chef) [![Cookbook Version](https://img.shields.io/cookbook/v/sensu.svg)](https://supermarket.chef.io/cookbooks/sensu)[![Build Status](https://jenkins-01.eastus.cloudapp.azure.com/job/sensu-cookbook/badge/icon)](https://jenkins-01.eastus.cloudapp.azure.com/job/sensu-cookbook/)

## Description

This cookbook provides custom resources and service recipes to install and configure
[Sensu](https://github.com/sensu/sensu/wiki), a monitoring framework.

The custom resources provide building blocks for creating a monitoring
cookbook specific to your environment (wrapper). **Without such a
wrapper, no Sensu configuration files will be created for your nodes.**

An example wrapper cookbook can be found [HERE](https://github.com/portertech/chef-monitor).

[How to Write Reusable Chef Cookbooks](http://bit.ly/10r993N)

## Contributing

See CODE_OF_CONDUCT.md, CONTRIBUTING.md and TESTING.md documents.


## Dependencies

### Platforms

* Ubuntu/Debian
* RHEL and derivatives
* Fedora
* Windows
* AIX

### Chef

* Chef 12+

### Cookbooks

* [APT](https://supermarket.chef.io/cookbooks/apt)
* [YUM](https://supermarket.chef.io/cookbooks/yum)
* [Windows](https://supermarket.chef.io/cookbooks/windows)
* [RabbitMQ](https://supermarket.chef.io/cookbooks/rabbitmq)
* [RedisIO](https://supermarket.chef.io/cookbooks/redisio)
* [ms_dotnet](https://supermarket.chef.io/cookbooks/ms_dotnet)

**NOTE**: This cookbook either constrains its dependencies optimistically (`>=`) or
 not at all. You're strongly encouraged to more strictly manage these
 dependencies in your wrapper cookbook.

## Package versioning

This cookbook makes no attempt to manage the versions of its package
dependencies. If you desire or require management of these versions, you should
handle these via your wrapper cookbook.

## Prerequisites

### SSL configuration

Running Sensu with SSL is recommended; by default this cookbook attempts to load
SSL credentials from a data bag `sensu`, with an item `ssl`, containing the
required SSL certificates and keys. These data bag items may be encrypted via
native Chef encrypted data bags or via Chef Vault.

The data loaded from the data bag by default is expected to be formatted as
follows:

```json
{
  "server": {
    "cert": "CERTIFICATE_DATA",
    "key": "PRIVATE_KEY_DATA",
    "cacert": "CA_CERTIFICATE_DATA"
  },
  "client": {
    "cert": "CERTIFICATE_DATA",
    "key": "PRIVATE_KEY_DATA"
  }
}
```

All of the above values are expected to be strings comprised of PEM-formatted
credentials with escaped line endings. See
`test/integration/data_bags/sensu/ssl.json` for a more literal example.

If the attempt to load SSL credentials from a data bag fails, the cookbook will
log a warning but proceed with the rest of the Chef run anyway, on the
assumption that credentials will be inserted into the Chef "run state" (i.e.
`node.run_state['sensu']['ssl']`) in the same format using the
`Sensu::ChefRunState` helper methods, `set_sensu_run_state` and
`get_sensu_run_state`.

Please see the [documentation for the run state helper
methods](#helper-modules-and-methods) for more information.

This cookbook comes with a tool to generate the certificates and data bag items.
If the integrity of the certificates is ever compromised, you must regenerate
and redeploy them.

```
cd examples/ssl
./ssl_certs.sh generate
knife data bag create sensu
```

Use the plain-text data bag item:

``` shell
knife data bag from file sensu ssl.json
```

Or, encrypt it with your data bag secret. See [Encrypt a Data Bag](https://docs.getchef.com/essentials_data_bags.html#encrypt-a-data-bag-item)
for more information.

```
knife data bag --secret-file /path/to/your/secret from file sensu ssl.json
```

``` shell
./ssl_certs.sh clean
```

## Recipes

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

### sensu::enterprise_dashboard

Installs and configures Sensu Enterprise Dashboard.

### sensu::enterprise_dashboard_service

Enables and starts Sensu Enterprise Dashboard.

## Attributes

### Installation

`node["sensu"]["version"]` - Sensu build to install.

`node["sensu"]["use_unstable_repo"]` - If the build resides on the
"unstable" repository.

`node["sensu"]["directory"]` - Sensu configuration directory.

`node["sensu"]["log_directory"]` - Sensu log directory.

`node["sensu"]["log_level"]` - Sensu log level (eg. "warn").

`node["sensu"]["use_ssl"]` - If Sensu and RabbitMQ are to use SSL.

`node["sensu"]["user"]` - The user who owns all sensu files and directories. Default
"sensu".

`node["sensu"]["group"]` - The group that owns all sensu files and directories.
Default "sensu".

`node["sensu"]["use_embedded_ruby"]` - If Sensu Ruby handlers and plugins
use the embedded Ruby in the Sensu package (default: true).

`node["sensu"]["service_max_wait"]` - How long service scripts should wait
for Sensu to start/stop.

`node["sensu"]["loaded_tempfile_dir"]` - Where Sensu stores temporary files. Set a persistent directory if you use hardened system that cleans temporary directory regularly.

### Windows

Sensu requires Microsoft's .Net Framework to run on Windows. The following attributes influence the installation of .Net via this cookbook:

`node["sensu"]["windows"]["install_dotnet"]` - Toggles installation of .Net Framework using ms_dotnet cookbook. (default: true)

`node["sensu"]["windows"]["dotnet_major_version"]` - Major version of .Net Framework to install. (default: 4)

Adjusting the value of `dotnet_major_version` attribute will influence which
 recipe from `ms_dotnet` cookbook will be included. See [`ms_dotnet` cookbook](https://github.com/criteo-cookbooks/ms_dotnet/blob/v2.6.1/README.md)
 for additional details on using this cookbook.

### Transport

`node["sensu"]["transport"]["name"]` - Name of transport to use for Sensu communications. Default "rabbitmq"

### RabbitMQ

`node["sensu"]["rabbitmq"]["hosts"]` - Array of RabbitMQ hosts as strings, which will be combined with other RabbitMQ attributes to generate the Sensu RabbitMQ transport configuration as an array of hashes. Falls back to `node["sensu"]["rabbitmq"]["host"]` when empty. Defaults to an empty array.

`node["sensu"]["rabbitmq"]["host"]` - RabbitMQ host.

`node["sensu"]["rabbitmq"]["port"]` - RabbitMQ port, usually for SSL.

`node["sensu"]["rabbitmq"]["ssl"]` - RabbitMQ SSL configuration, DO NOT EDIT THIS.

`node["sensu"]["rabbitmq"]["vhost"]` - RabbitMQ vhost for Sensu.

`node["sensu"]["rabbitmq"]["user"]` - RabbitMQ user for Sensu.

`node["sensu"]["rabbitmq"]["password"]` - RabbitMQ password for Sensu.

### Redis

`node["sensu"]["redis"]["host"]` - Redis host.

`node["sensu"]["redis"]["port"]` - Redis port.

### Sensu API

`node["sensu"]["api"]["host"]` - Sensu API host, for other services to reach it.

`node["sensu"]["api"]["bind"]` - Sensu API bind address.

`node["sensu"]["api"]["port"]` - Sensu API port.

### Sensu Enterprise

`node["sensu"]["enterprise"]["repo_protocol"]` - Sensu Enterprise repo protocol (e.g. http, https)

`node["sensu"]["enterprise"]["repo_host"]` - Sensu Enterprise repo host

`node["sensu"]["enterprise"]["version"]` - Desired Sensu Enterprise package version

`node["sensu"]["enterprise"]["use_unstable_repo"]` - Toggle use of Sensu Enterprise unstable repository

`node["sensu"]["enterprise"]["log_level"]` - Configure Sensu Enterprise log level

`node["sensu"]["enterprise"]["heap_size"]` - Configure Sensu Enterprise heap size

`node["sensu"]["enterprise"]["heap_dump_path"]` - Configure path where Sensu Enterprise will store heap dumps. Directory path will be managed by Chef. Honored by Enterprise version 2.0.0 and newer.

`node["sensu"]["enterprise"]["java_opts"]` - Specify additional Java options when running Sensu Enterprise

`node["sensu"]["enterprise"]["max_open_files"]` - Specify maxiumum number of file handles. Honored by Enterprise version 1.7.2 and newer.

## Custom Resources (LWRPs)

### Define a client

```ruby
sensu_client node["name"] do
  address node["ipaddress"]
  subscriptions node["roles"] + ["all"]
  additional(:cluster => node["cluster"])
end
```

The `sensu_client` provider also supports the following optional attributes:

* deregister
* deregistration
* keepalive
* keepalives
* redact
* registration
* safe_mode
* socket

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
  days(
    :all => [{ :begin => "05:00 PM", :end => "09:00 AM" }}],
    :saturday => [{ :begin => "09:00 AM", :end => "05:00 PM" }],
    :sunday => [{ :begin => "09:00 AM", :end => "05:00 PM" }]
  )
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

## Helper modules and methods

### Run State Helpers

The `Sensu::ChefRunState` module provides helper methods which populate `node.run_state['sensu']` with arbitrary key/value pairs. This provides a means for wrapper cookbooks to populate the `node.run_state` with data required by the cookbook, e.g. SSL credentials, without cookbook itself enforcing source for that data.

**NOTE**: The `node.run_state` is not persisted locally nor on a Chef server. Data stored here exists only for the duration of the Chef run.

#### `set_sensu_state`

This method sets values inside the `node.run_state['sensu']` Mash, and expects arguments in the following order:

1. the Chef `node` object
2. one or more keys, providing the path to walk
3. the value to set at that path

Example:

`set_sensu_state(node, 'food', 'nachos', true)`

The above sets the value of `node.run_state['sensu']['food']['nachos']` to `true`.

#### `get_sensu_state`

This method retrieves the value of a key inside the `node.run_state['sensu']` Mash and expects arguments in the following order:

1. the Chef `node` object
2. one or more keys, providing the path to walk

Examples:

`get_sensu_state(node, 'food', 'nachos')` would return `true`

When no value is set for a requested path, this method returns `nil`:

`get_sensu_state(node, 'this', 'path', 'is', 'invalid')` returns `nil`

## Support

Please visit [sensuapp.org/support](http://sensuapp.org/support) for details on community and commercial
support resources, including the official IRC channel.
