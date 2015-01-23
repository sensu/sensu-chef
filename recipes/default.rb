#
# Cookbook Name:: sensu
# Recipe:: default
#
# Copyright 2014, Sonian Inc.
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

ruby_block "sensu_service_trigger" do
  block do
    # Sensu service action trigger for LWRPs.
    # This resource must be defined before the Sensu LWRPs can be used.
  end
  action :nothing
end

if platform_family?("windows")
  include_recipe "sensu::_windows"
else
  include_recipe "sensu::_linux"
end

directory node.sensu.log_directory do
  owner node.sensu.user
  group node.sensu.group
  recursive true
  mode node.sensu.log_directory_mode
end

%w[
  conf.d
  plugins
  handlers
  extensions
].each do |dir|
  directory File.join(node.sensu.directory, dir) do
    owner node.sensu.admin_user
    group node.sensu.group
    recursive true
    mode node.sensu.directory_mode
  end
end

if node.sensu.use_ssl
  node.override.sensu.rabbitmq.ssl = Mash.new
  node.override.sensu.rabbitmq.ssl.cert_chain_file = File.join(node.sensu.directory, "ssl", "cert.pem")
  node.override.sensu.rabbitmq.ssl.private_key_file = File.join(node.sensu.directory, "ssl", "key.pem")

  directory File.join(node.sensu.directory, "ssl") do
    owner node.sensu.admin_user
    group node.sensu.group
    mode 0750
  end

  ssl = Sensu::Helpers.data_bag_item("ssl")

  file node.sensu.rabbitmq.ssl.cert_chain_file do
    content ssl["client"]["cert"]
    owner node.sensu.admin_user
    group node.sensu.group
    mode 0640
  end

  file node.sensu.rabbitmq.ssl.private_key_file do
    content ssl["client"]["key"]
    owner node.sensu.admin_user
    group node.sensu.group
    mode 0640
  end
else
  if node.sensu.rabbitmq.port == 5671
    Chef::Log.warn("Setting Sensu RabbitMQ port to 5672 as you have disabled SSL.")
    node.override.sensu.rabbitmq.port = 5672
  end
end

sensu_base_config node.name
