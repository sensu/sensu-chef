# installation
default.sensu.version = "0.9.12-2"
default.sensu.use_unstable_repo = false
default.sensu.directory = "/etc/sensu"
default.sensu.log_directory = "/var/log/sensu"
default.sensu.use_ssl = true
default.sensu.use_embedded_ruby = false

# rabbitmq
default.sensu.rabbitmq.host = "localhost"
default.sensu.rabbitmq.port = 5671
default.sensu.rabbitmq.vhost = "/sensu"
default.sensu.rabbitmq.user = "sensu"
default.sensu.rabbitmq.password = "password"

# redis
default.sensu.redis.host = "localhost"
default.sensu.redis.port = 6379

# api
default.sensu.api.host = "localhost"
default.sensu.api.port = 4567

# dashboard
default.sensu.dashboard.bind = "0.0.0.0"
default.sensu.dashboard.port = 8080
default.sensu.dashboard.user = "admin"
default.sensu.dashboard.password = "secret"
