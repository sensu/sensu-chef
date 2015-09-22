# installation
default["sensu"]["enterprise-dashboard"]["version"] = "1:1.4.0-1"

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
