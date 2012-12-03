name             "sensu"
maintainer       "Sonian, Inc."
maintainer_email "chefs@sonian.net"
license          "Apache 2.0"
description      "Installs/Configures Sensu"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.2"

# available @ http://community.opscode.com/cookbooks/apt
depends "apt"

# available @ http://community.opscode.com/cookbooks/yum
depends "yum"

# available @ http://community.opscode.com/cookbooks/rabbitmq
depends "rabbitmq"

# available @ https://github.com/miah/chef-redis
depends "redis"

# available @ https://github.com/infochimps-labs/ironfan-pantry/cookbooks/silverware
depends "silverware"

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
