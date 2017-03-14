# Due to a packaging error, debian versions are prefixed with an epoch, i.e.
# "1:", which is not present on the rpm packages. As a result, we use the
# platform_family to determine correct default version.
#
default["sensu"]["enterprise-dashboard"]["version"] = node['platform_family'] == 'debian' ? "1:2.3.0-1" : "2.3.0-1"

# data bag
default["sensu"]["enterprise-dashboard"]["data_bag"]["name"] = "sensu"
default["sensu"]["enterprise-dashboard"]["data_bag"]["config_item"] = "enterprise_dashboard"

# dashboard options
default["sensu"]["enterprise-dashboard"]["dashboard"]["host"] = "0.0.0.0"
default["sensu"]["enterprise-dashboard"]["dashboard"]["port"] = 3000
default["sensu"]["enterprise-dashboard"]["dashboard"]["refresh"] = 5
default["sensu"]["enterprise-dashboard"]["dashboard"]["user"] = "admin"
default["sensu"]["enterprise-dashboard"]["dashboard"]["pass"] = "secret"

# sensu datacenters
default["sensu"]["enterprise-dashboard"]["sensu"] = []
