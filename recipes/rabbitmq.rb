#
# Cookbook Name:: sensu
# Recipe:: rabbitmq
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

if node.sensu.ssl
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

if node.platform == "ubuntu" && %w[10.04 10.10 11.04].include?(node.lsb.release)
  include_recipe "apt"

  apt_repository "esl" do
    uri "http://binaries.erlang-solutions.com/debian"
    distribution node.lsb.codename
    components ["contrib"]
    key "http://binaries.erlang-solutions.com/debian/erlang_solutions.asc"
    action :add
  end

  package "esl-erlang"
else
  include_recipe "erlang"
end

include_recipe "rabbitmq"

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

if node.sensu.firewall
  include_recipe "iptables"

  iptables_rule "port_rabbitmq"
end
