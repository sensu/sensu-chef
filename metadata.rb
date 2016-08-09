name             "sensu"
maintainer       "Sonian, Inc."
maintainer_email "chefs@sonian.net"
license          "Apache 2.0"
description      "Installs/Configures Sensu"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.0.0"

# available @ https://supermarket.chef.io/cookbooks/apt
depends "apt"

# available @ https://supermarket.chef.io/cookbooks/yum
depends "yum"

# available @ https://supermarket.chef.io/cookbooks/windows
depends "windows", ">= 1.8.8"

# available @ https://supermarket.chef.io/cookbooks/ms_dotnet
depends "ms_dotnet", ">= 2.6.1"

# available @ https://supermarket.chef.io/cookbooks/rabbitmq
depends "rabbitmq", ">= 2.0.0"

# available @ https://supermarket.chef.io/cookbooks/redisio
depends "redisio", ">= 1.7.0"

# available @ https://supermarket.chef.io/cookbooks/chef-vault
suggests "chef-vault", ">= 1.3.1"

%w[
  ubuntu
  debian
  centos
  redhat
  fedora
  scientific
  oracle
  amazon
  windows
].each do |os|
  supports os
end

source_url 'https://github.com/sensu/sensu-chef' if respond_to?(:source_url)
issues_url 'https://github.com/sensu/sensu-chef/issues' if respond_to?(:issues_url)
