name             "sensu"
maintainer       "Heavy Water Operations"
maintainer_email "support@sensuapp.com"
license          "Apache 2.0"
description      "Installs/Configures Sensu"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.1.3"

# available @ https://supermarket.chef.io/cookbooks/apt
depends "apt", ">= 2.0"

# available @ https://supermarket.chef.io/cookbooks/yum
depends "yum", ">= 3.0"

# available @ https://supermarket.chef.io/cookbooks/windows
depends "windows", ">= 1.36"

# available @ https://supermarket.chef.io/cookbooks/ms_dotnet
depends "ms_dotnet", ">= 2.6.1"

# available @ https://supermarket.chef.io/cookbooks/rabbitmq
depends "rabbitmq", ">= 2.0.0"

# available @ https://supermarket.chef.io/cookbooks/redisio
depends "redisio", ">= 1.7.0"

# available @ https://supermarket.chef.io/cookbooks/chef-vault
suggests "chef-vault", ">= 1.3.1"

%w[
  aix
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

source_url 'https://github.com/sensu/sensu-chef'
issues_url 'https://github.com/sensu/sensu-chef/issues'
chef_version '>= 12.0'
