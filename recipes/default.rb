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

ruby_block "sensu_service_trigger" do
  block do
    # Sensu service action trigger for LWRP's
  end
  action :nothing
end

case node.platform
when "windows"
  include_recipe "sensu::windows"
else
  include_recipe "sensu::linux"
end

[
  File.join(node.sensu.directory, "conf.d"),
  node.sensu.log.directory
].each do |dir|
  directory dir do
    recursive true
    owner "sensu"
    mode 0755
  end
end

if node.sensu.ssl
  node.set.sensu.rabbitmq.ssl.cert_chain_file = File.join(node.sensu.directory, "ssl", "cert.pem")
  node.set.sensu.rabbitmq.ssl.private_key_file = File.join(node.sensu.directory, "ssl", "key.pem")

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
else
  node.sensu.rabbitmq.delete(:ssl)

  if node.sensu.rabbitmq.port == 5671
    Chef::Log.warn("Setting Sensu RabbitMQ port to 5672 as you have disabled SSL.")
    node.set.sensu.rabbitmq.port = 5672
  end
end

sensu_config node.name
