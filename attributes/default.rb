# installation
default.sensu.version = "0.9.8-1"
default.sensu.use_unstable_repo = false
default.sensu.directory = "/etc/sensu"
default.sensu.log_directory = "/var/log/sensu"
default.sensu.use_ssl = true
default.sensu.use_embedded_ruby = false

# rabbitmq
default.sensu.rabbitmq.host = "localhost"
default.sensu.rabbitmq.port = 5671
default.sensu.rabbitmq.ssl = Mash.new
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
default.sensu.dashboard.port = 8080
default.sensu.dashboard.user = "admin"
default.sensu.dashboard.password = "secret"

# admin
default.sensu.admin.host = "localhost"
default.sensu.admin.http_port = 80
default.sensu.admin.https_port = 443
default.sensu.admin.backend_port = 8888
default.sensu.admin.repo = "https://github.com/sensu/sensu-admin.git"
default.sensu.admin.release = "v0.0.3" # Version locked, if you want the latest use development, if you want some stability use master. YMMV.
default.sensu.admin.base_path = "/opt/sensu/admin" # Omnibus sensu lives here
default.sensu.admin.ssl.country = 'US'
default.sensu.admin.ssl.state = 'MA'
default.sensu.admin.ssl.city = 'Boston'
default.sensu.admin.ssl.company = 'MyCo, Inc'
default.sensu.admin.ssl.email = 'chefs@mydomain.net'
default.sensu.admin.ssl.domain = 'mydomain.net'
default.sensu.admin.ssl.department = 'DEVOPS'

# client
default.sensu.client = Hash.new
