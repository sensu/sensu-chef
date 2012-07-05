name             "sensu"
maintainer       "Sonian, Inc."
maintainer_email "chefs@sonian.net"
license          "Apache 2.0"
description      "Installs/Configures Sensu"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

# available @ http://community.opscode.com/cookbooks/apt
depends "apt"

# available @ http://community.opscode.com/cookbooks/yum
depends "yum"

# available @ http://community.opscode.com/cookbooks/rabbitmq
depends "rabbitmq"

# available @ https://github.com/miah/chef-redis
depends "redis"

# available @ http://community.opscode.com/cookbooks/iptables
depends "iptables"

%w[
  ubuntu
  debian
  centos
  redhat
  windows
].each do |os|
  supports os
end
