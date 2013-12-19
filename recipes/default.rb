#
# Cookbook Name:: sensu
# Recipe:: default
#
# Copyright 2012, Sonian Inc.
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
    # Sensu service action trigger for LWRP's
  end
  action :nothing
end

case node.platform
when "windows"
  include_recipe "sensu::_windows"
else
  include_recipe "sensu::_linux"
end

directory node.sensu.log_directory do
  owner "sensu"
  group "sensu"
  recursive true
  mode 0750
end
  
directory File.join(node.sensu.directory, "conf.d") do
  owner "root"
  group "sensu"
  recursive true
  mode 0750
end

if node.sensu.use_ssl
  node.override.sensu.rabbitmq.ssl = Mash.new
  node.override.sensu.rabbitmq.ssl.cert_chain_file = File.join(node.sensu.directory, "ssl", "cert.pem")
  node.override.sensu.rabbitmq.ssl.private_key_file = File.join(node.sensu.directory, "ssl", "key.pem")

  directory File.join(node.sensu.directory, "ssl")

  ssl = Sensu::Helpers.data_bag_item("ssl")

  file node.sensu.rabbitmq.ssl.cert_chain_file do
    content ssl["client"]["cert"]
    owner "root"
    group "sensu"
    mode 0640
  end

  file node.sensu.rabbitmq.ssl.private_key_file do
    content ssl["client"]["key"]
    owner "root"
    group "sensu"
    mode 0640
  end
else
  if node.sensu.rabbitmq.port == 5671
    Chef::Log.warn("Setting Sensu RabbitMQ port to 5672 as you have disabled SSL.")
    node.override.sensu.rabbitmq.port = 5672
  end
end

sensu_base_config node.name
