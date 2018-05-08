# Sensu cookbook changelog

This file is used to track changes made in recent versions of the Sensu
cookbook. Please see HISTORY.md for changes from older versions of this project.

## [Unreleased]

## [5.1.0] - 2018-05-08
### Fixed
- fixed pulling newer sensu packages on windows as the repo structure changed and needs to include the os version (@ridiculousness)

### Added
- logrotate in windows (@ridiculousness)

## [5.0.0] - 2018-05-04
### Breaking Changes
- removed legacy `apt` and `yum` dependencies and require chef client `>= 12.14` (@tas50)

## [4.4.0] - 2018-05-04
### Added
- native support for `ttl` checks (@majormoses)

## [4.3.1] - 2018-04-11
### Fixed
- reverted #468 per #564 (@majormoses)

## [4.3.0] - 2018-03-28
### Added
- pulling in latest release `redisio` cookbook to fix chef 13 compatibility (@majormoses)

## [4.2.1] - 2018-03-04
### Security
* Enable gpg check for all linux repo installs using a key downloaded over HTTPS. Download windows MSI over HTTPS. #578 (@mike-stewart)

## [4.2.0] - 2018-02-16
### Added
* native support for proxy client checks (formerly known as JIT) to the `check` provider by accepting a `source` parameter (@majormoses)
* misc development dependencies that were missing (@majormoses)

## [4.1.0] - 2017-12-14
### Added
* ability to control `yum_package`'s `flush_cache` parameter by specifying `node['sensu']['yum_flush_cache']`. This allows you to control chefs in memory cache during a `chef-client` run. For more information see [here](https://docs.chef.io/resource_yum.html).
* `sensu_gem` now optionally accepts a `source` parameter of `String` or `Array` when using an action of `:upgrade`.This could be a local file or a URL. For more information see [here](https://docs.chef.io/resource_gem_package.html)

## [4.0.6] - 2017-09-12

### Fixed

* on systems with restrictive umasks the permissions for rabbitmq ssl directories ended up with permissions that made it non functional. This sets them to the required permissions to make things work (@jessebolson)

## [4.0.5] - 2017-09-12

### Fixed

* `client.json` should now be used by `node['sensu']['user']` rather than `node['sensu']['admin_user']`

## [4.0.4] - 2017-09-12

### Features

* added example in `README.md` how to easily install a bunch of sensu plugins into the emebedded ruby context (@majormoses)

## [4.0.3] - 2017-09-12

### Features

* added support for suse linux (@runningman84)

## [4.0.2] - 2017-07-06

### Changes

* Tests now run via ChefDK

### Fixed

* Updated node attribute syntax for Chef 13 compatibility
* Updated recipes to allow for "amazon" platform family under Chef 13

### Features

* When given a value, `node["sensu"]["yum_repo_releasever"]` attribute will be
used in lieu of `$releasever` yum variable, restoring support for RHEL
derivatives, e.g. Amazon Linux.

* When given a value, `node["sensu"]["apt_repo_codename"]` attribute will be
used in lieu of the LSB codename detected by ohai on Debian and Ubuntu.

## [4.0.0] - 2017-03-14

### Important

* Due to sysv init scripts being replaced with systemd unit files on
  select platforms, upgrading Sensu package from version < 0.27 to >=
  0.27 may leave Sensu services in an unexpected state. This cookbook does not
  attempt to address this condition. See the
  [Sensu 0.27 changelog][027-changelog] for further details.

As required to support Sensu 0.27 and later:

* Configuration of yum and apt package repositories have changed to target
  per-platform version packages, using `$releasever` or release codename,
  respectively.

* The `init_style` attribute has been removed from `sensu_service` resource.
  The `sensu_service` resource will now use Chef's default `service`
  provider on each platform.

### Changes

The default version of Sensu is now 0.28.4

The default version of Sensu Enterprise is now 2.5.1

The default version of Sensu Enterprise Dashboard is now 2.3.0

### Fixed

* sensu_check resources can now be deleted without requiring
  `standalone` or `subscriptions` attributes

* The built-in Administrator group should now be usable for the value
  of `node["sensu"]["group"]` on Windows platforms.

## [3.2.0] - 2017-01-10

### Important

The `runit` init_style is now deprecated and will be removed in the next
major version of this cookbook.

### Features

Added `days` parameter to `sensu_filter` resources. This parameter accepts
a hash of time windows passed as the value of a filter's `when`
attribute. See the [filter reference
doc](https://sensuapp.org/docs/0.26/reference/filters.html#when-attributes)
for more detail on time windows.

Added new attributes added for configuring Sensu Enterprise max open files
and heap dump path parameters.

### Changes

The default version of Sensu is now 0.26.5

The default version of Sensu Enterprise is now 1.14.10

The default version of Sensu Enterprise Dashboard is now 1.12.0

The account created for Sensu on Windows now uses the
`node["sensu"]["user"]` attribute instead of a hard-coded value.

### Project changes

For purposes of releasing this cookbook, emeril has been replaced with stove.

## [3.1.2] - 2016-09-29

### Changes

The `_enterprise_repo` recipe now configures yum repos for both `noarch`
and `$basearch` so that `sensu-enterprise-dashboard` package can be installed.

Due to upstream repository changes, the default value of
`node['sensu']['enterprise-dashboard]['version']` has changed from
`1:1.4.0-1` to `1.4.0-1`.

## [3.1.0] - 2016-09-23

### Changes

The default version of Sensu installed by this cookbook is now 0.26.3-1.

Eliminated resource cloning warnings when calling rabbitmq_credentials definition.

Replaced librarian-chef with Berkshelf.

Updated test-kitchen configuration for windows platforms.

Updated metadata to depend on Chef >= 12.

Updated dependencies for yum, apt and windows cookbooks to make sense for Chef >= 12.

### Features

Added support for AIX platform

Added support for configuring SENSU_LOADED_TEMPFILE_DIR via `node["sensu"]["loaded_tempfile_dir"]`

Added logic for detecting gem binary path on Windows platform

### Fixes

Using `baseurl` attribute for yum_repository instead of `url` property

Fixed broken tests for availability of `sensitive` attribute

## [3.0.0] - 2016-08-09

### Important

This cookbook now supports Chef version 12+. Earlier versions may work but
are not supported.

The default version of Sensu installed by this cookbook is now 0.25.6-1.

The default value of `node["sensu"]["use_embedded_ruby"]` is now `true`.

The `rabbitmq` recipe now installs Erlang via the Erlang Solutions repository on all platforms.

### Behavior changes

Installation of the .NET Framework is now handled by the [ms_dotnet](https://supermarket.chef.io/cookbooks/ms_dotnet) cookbook.

### Features

Sensu Enterprise repository URL is now configurable via attributes.

Sensu Enterprise JVM options are now configurable via attributes.

Sensu transport `name` is now configurable via attributes.

The `sensu_base_config` provider now honors `node["rabbitmq"]["hosts"]` attribute,
providing an array of hosts to use for configuring rabbitmq transport with multiple brokers.
When `hosts` attribute has no value, we fall back to value of `node["sensu"]["rabbitmq"]["host"]`
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

Check definition LWRP has been updated to support named aggregates (added
in Sensu 0.25) and multiple named aggregates (coming in Sensu 0.26).

Integration tests for Windows now use the new Chef Zero Scheduled
Task provider which makes testing this platform much easier.

Expanded unit tests in many areas, including `sensu_base_config`,
`sensu_client`, `sensu_json_file` and other LWRPs.

### Fixes

Directories created by the `sensu_json_file` provider now assume the mode
defined by the value of `node["sensu"]["directory_mode"]` attribute.

The method used to look up `sensu_service_trigger` ruby block in the
resource collection has been updated to eliminate conditions where Sensu
services may not be notified to restart.

Resources are now created by the `sensu_json_file` provider
unconditinally, unblocking the use of library cookbooks like [zap](https://supermarket.chef.io/cookbooks/zap) to
clean up unmanaged files on disk.


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

[Unreleased]: https://github.com/sensu/sensu-chef/compare/v5.0.0...HEAD
[6.0.0]: https://github.com/sensu/sensu-chef/compare/v5.0.0...v5.1.0
[5.0.0]: https://github.com/sensu/sensu-chef/compare/v4.4.0...v5.0.0
[4.4.0]: https://github.com/sensu/sensu-chef/compare/v4.3.1...v4.4.0
[4.3.1]: https://github.com/sensu/sensu-chef/compare/v4.3.0...v4.3.1
[4.3.0]: https://github.com/sensu/sensu-chef/compare/v4.2.1...v4.3.0
[4.2.1]: https://github.com/sensu/sensu-chef/compare/v4.2.0...v4.2.1
[4.2.0]: https://github.com/sensu/sensu-chef/compare/v4.1.0...v4.2.0
[4.1.0]: https://github.com/sensu/sensu-chef/compare/v4.0.6...v4.1.0
[4.0.6]: https://github.com/sensu/sensu-chef/compare/v4.0.5..v4.0.6
[4.0.5]: https://github.com/sensu/sensu-chef/compare/v4.0.4...v4.0.5
[4.0.4]: https://github.com/sensu/sensu-chef/compare/v4.0.3...v4.0.4
[4.0.3]: https://github.com/sensu/sensu-chef/compare/v4.0.2...v4.0.3
[4.0.2]: https://github.com/sensu/sensu-chef/compare/v4.0.0...v4.0.2
[4.0.0]: https://github.com/sensu/sensu-chef/compare/3.2.0...v4.0.0
[3.2.0]: https://github.com/sensu/sensu-chef/compare/3.1.2...3.2.0
[3.1.2]: https://github.com/sensu/sensu-chef/compare/3.1.0...3.1.2
[3.1.0]: https://github.com/sensu/sensu-chef/compare/3.0.0...3.1.0
[3.0.0]: https://github.com/sensu/sensu-chef/compare/2.12.0...3.0.0
[2.12.0]: https://github.com/sensu/sensu-chef/compare/2.11.0...2.12.0
[027-changelog]: https://sensuapp.org/docs/0.27/overview/changelog.html#core-v0-27-0-important
