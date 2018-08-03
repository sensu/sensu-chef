name             "sensu"
maintainer       "Heavy Water Operations"
maintainer_email "support@sensuapp.com"
license          "Apache-2.0"
description      "Installs/Configures Sensu"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "5.1.2"

# available @ https://supermarket.chef.io/cookbooks/windows
depends "windows", ">= 1.36"

# available @ https://supermarket.chef.io/cookbooks/ms_dotnet
depends "ms_dotnet", ">= 2.6.1"

# available @ https://supermarket.chef.io/cookbooks/rabbitmq
suggests "rabbitmq", ">= 2.0.0"

# available @ https://supermarket.chef.io/cookbooks/redisio
suggests "redisio", ">= 2.7.0"

# available @ https://supermarket.chef.io/cookbooks/chef-vault
suggests "chef-vault", ">= 1.3.1"

# available @ https://supermarket.chef.io/cookbooks/zypper
suggests "zypper", ">= 0.4.0"

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
  suse
  windows
].each do |os|
  supports os
end

source_url 'https://github.com/sensu/sensu-chef'
issues_url 'https://github.com/sensu/sensu-chef/issues'
chef_version '>= 13.3'
