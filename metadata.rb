name             "sensu"
maintainer       "Sensu Community"
maintainer_email "support@sensuapp.com"
license          "Apache-2.0"
description      "Installs/Configures Sensu"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "5.0.0"

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
chef_version '>= 12.1'