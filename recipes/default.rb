#
# Cookbook Name:: sensu
# Recipe:: default
#
# Copyright 2011, Sonian Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node.sensu.rabbitmq.ssl.cert_chain_file = File.join(node.sensu.directory, "ssl", "cert.pem")
node.sensu.rabbitmq.ssl.private_key_file = File.join(node.sensu.directory, "ssl", "key.pem")

case node.platform
when "ubuntu", "debian"
  include_recipe "apt"

  apt_repository "sensu" do
    uri "http://repos.sensuapp.org/apt"
    distribution "sensu"
    components ["main"]
    action :add
  end
when "centos", "redhat"
  include_recipe "yum"

  yum_repository "sensu" do
    url "http://repos.sensuapp.org/yum"
    action :add
  end
end

package "sensu" do
  version node.sensu.version
  options "--force-yes"
end

gem_package "sensu-plugin" do
  version node.sensu.plugin.version
end

if node.sensu.sudoers
  template "/etc/sudoers.d/sensu" do
    source "sudoers.erb"
    mode 0440
  end
end

directory File.join(node.sensu.directory, 'conf.d') do
  recursive true
end

include_recipe "sensu::dependencies"

directory node.sensu.log.directory do
  recursive true
  owner "sensu"
  mode 0755
end

remote_directory File.join(node.sensu.directory, "plugins") do
  files_mode 0755
end

directory File.join(node.sensu.directory, "ssl")

ssl = data_bag_item("sensu", "ssl")

file node.sensu.rabbitmq.ssl.cert_chain_file do
  content ssl["client"]["cert"]
  mode 0644
end

file node.sensu.rabbitmq.ssl.private_key_file do
  content ssl["client"]["key"]
  mode 0644
end

if(RUBY_VERSION < '1.9.0')
  g = gem_package('orderedhash')do
    action :nothing
  end
  g.run_action(:install)
  Gem.clear_paths
  require 'orderedhash'
end

file File.join(node.sensu.directory, "config.json") do
  content Sensu.generate_config(node, data_bag_item("sensu", "config"))
  mode 0644
end
