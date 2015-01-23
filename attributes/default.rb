# platform
if platform_family?("windows")
  default.sensu.admin_user = "Administrator"
  default.sensu.directory = 'C:\etc\sensu'
  default.sensu.log_directory = 'C:\var\log\sensu'
  default.sensu.windows.dism_source = nil
  default.sensu.windows.package_options = nil
else
  default.sensu.admin_user = "root"
  default.sensu.user = "sensu"
  default.sensu.group = "sensu"
  default.sensu.directory = "/etc/sensu"
  default.sensu.directory_mode = "0750"
  default.sensu.log_directory = "/var/log/sensu"
  default.sensu.log_directory_mode = "0750"
end

# installation
default.sensu.version = "0.16.0-1"
default.sensu.use_unstable_repo = false
default.sensu.log_level = "info"
default.sensu.use_ssl = true
default.sensu.use_embedded_ruby = false
default.sensu.init_style = "sysv"
default.sensu.service_max_wait = 10

default.sensu.apt_repo_url = "http://repos.sensuapp.org/apt"
default.sensu.yum_repo_url = "http://repos.sensuapp.org"
default.sensu.msi_repo_url = "http://repos.sensuapp.org/msi"

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
default.sensu.api.bind = "0.0.0.0"
default.sensu.api.port = 4567
