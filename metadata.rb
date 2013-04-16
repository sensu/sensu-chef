name             "sensu"
maintainer       "Sonian, Inc."
maintainer_email "chefs@sonian.net"
license          "Apache 2.0"
description      "Installs/Configures Sensu"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.5.0"

# available @ http://community.opscode.com/cookbooks/apt
depends "apt"

# available @ http://community.opscode.com/cookbooks/yum
depends "yum"

# available @ http://community.opscode.com/cookbooks/windows
depends "windows"

# available @ http://community.opscode.com/cookbooks/rabbitmq
depends "rabbitmq"

# available @ https://github.com/miah/chef-redis
depends "redis"

%w[
  ubuntu
  debian
  centos
  redhat
  fedora
  windows
].each do |os|
  supports os
end
