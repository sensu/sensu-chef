#
# Cookbook Name:: sensu
# Recipe:: rabbitmq
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

if node.sensu.use_ssl
  node.set.rabbitmq.ssl = true
  node.set.rabbitmq.ssl_port = node.sensu.rabbitmq.port

  ssl_directory = "/etc/rabbitmq/ssl"

  directory ssl_directory do
    recursive true
  end

  ssl = data_bag_item("sensu", "ssl")

  %w[
    cacert
    cert
    key
  ].each do |item|
    path = File.join(ssl_directory, "#{item}.pem")
    file path do
      content ssl["server"][item]
      mode 0644
    end
    node.set.rabbitmq["ssl_#{item}"] = path
  end
end

include_recipe "rabbitmq"
include_recipe "rabbitmq::mgmt_console"

rabbitmq_vhost node.sensu.rabbitmq.vhost do
  action :add
end

rabbitmq_user node.sensu.rabbitmq.user do
  password node.sensu.rabbitmq.password
  action :add
end

rabbitmq_user node.sensu.rabbitmq.user do
  vhost node.sensu.rabbitmq.vhost
  permissions "\".*\" \".*\" \".*\""
  action :set_permissions
end

# Announce via Silverware
announce(:sensu, :rabbitmq, {
  :port      => node[:sensu][:rabbitmq][:port],
  :ssl       => Mash.new().merge(node[:sensu][:rabbitmq][:ssl]),
  :vhost     => node[:sensu][:rabbitmq][:vhost],
  :user      => node[:sensu][:rabbitmq][:user],
  :password  => node[:sensu][:rabbitmq][:password],
})
