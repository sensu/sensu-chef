# Sensu cookbook changelog

This file is used to track changes made in recent versions of the Sensu
cookbook. Please see HISTORY.md for changes from older versions of this project.

## [Unreleased]

### Important

* The `rabbitmq` recipe now installs Erlang via the Erlang Solutions repository on all platforms

### Features

The `sensu_base_config` provider now honors `node["rabbitmq"]["hosts"]` attribute,
providing an array of hosts to use for configuring rabbitmq transport with multiple brokers.
When `hosts` is empty, we fall back to existing `node["sensu"]["rabbitmq"]["host"]`
attribute.

The `sensu_client` provider now honors the following additional client
attributes, as defined in the [Sensu Client Reference Documentation](https://sensuapp.org/docs/0.25/reference/clients.html#client-attributes):

  * deregister
  * deregistration
  * keepalives
  * redact
  * registration
  * safe_mode
  * socket

## [2.12.0] - 2016-03-14

### Project changes

The Sensu cookbook project has adopted a new contribution workflow and a
new code of conduct policy. Please see the relevant documents in
repo for details.

### Behavior changes

Values for `owner` and `group` properties on `sensu_json_file` resources
now default to lazy evaluation of node attributes `sensu.admin_user` and
`sensu.group` respectively. (#426)

Data bags remain default source of SSL certificates, but are now optional:

	With the addition of Sensu state helpers in #410 recipes which
	access credentials via data bags (i.e. `default`, `rabbitmq` and
	`enterprise` recipes) have been updated to make these data bag
	items optional.

	Please see the readme and integration test suite for examples of
	using these helpers.

Testing notes have been added in `TESTING.md` to describe some of the
platform/suite combinations which are disabled or otherwise
require special configuration.

### Features

Added [ChefSpec](https://github.com/sethvargo/chefspec) test coverage for the following:

* `default` and `client_service` recipes
* `sensu_gem` LWRP
* Sensu::Helpers library `#select_attributes` and `#gem_binary`  methods

Added source attribute to sensu_gem resource
Added upgrade action to sensu_gem resource
Added helpers for storing key/value pairs which persist for duration of the Chef run

### Fixes

Allow "standard" as a value of type attribute on `sensu_check` resources, [as described in Sensu documentation](https://sensuapp.org/docs/0.21/checks).

[Unreleased]: https://github.com/sensu/sensu-chef/compare/2.12.0...HEAD
[2.12.0]: https://github.com/sensu/sensu-chef/compare/2.11.0...2.12.0
