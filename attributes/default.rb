## most of these values can be replaced with your method of discovery

# installation
default.sensu.version = "0.9.7-1"
default.sensu.plugin.version = "0.1.4"
default.sensu.directory = "/etc/sensu"
default.sensu.log.directory = "/var/log/sensu"
default.sensu.ssl = true
default.sensu.sudoers = false
default.sensu.firewall = false
default.sensu.package.unstable = false

# rabbitmq
default.sensu.rabbitmq_hostname = ""
default.sensu.rabbitmq_password = "secret"

# redis
default.sensu.redis.host = "localhost"
default.sensu.redis.port = 6379

# api
default.sensu.api.host = "localhost"
default.sensu.api.port = 4567

# dashboard
default.sensu.dashboard.host = "localhost"
default.sensu.dashboard.port = 8080
default.sensu.dashboard.user = "admin"
default.sensu.dashboard.password = "secret"

# client
default.sensu.client = Hash.new
