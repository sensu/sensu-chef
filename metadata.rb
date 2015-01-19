name             "sensu"
maintainer       "Sonian, Inc."
maintainer_email "chefs@sonian.net"
license          "Apache 2.0"
description      "Installs/Configures Sensu"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "2.3.0"

# available @ http://supermarket.chef.io/cookbooks/apt
depends "apt"

# available @ http://supermarket.chef.io/cookbooks/yum
depends "yum"

# available @ http://supermarket.chef.io/cookbooks/windows
depends "windows", ">= 1.8.8"

# available @ http://supermarket.chef.io/cookbooks/rabbitmq
depends "rabbitmq", ">= 2.0.0"

# available @ http://supermarket.chef.io/cookbooks/redisio
depends "redisio", ">= 1.7.0"

# available @ https://supermarket.chef.io/cookbooks/chef-sugar
depends "chef-sugar"

%w[
  ubuntu
  debian
  centos
  redhat
  fedora
  amazon
  windows
].each do |os|
  supports os
end
