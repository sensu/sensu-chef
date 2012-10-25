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

node.set.rabbitmq.ssl = true
node.set.rabbitmq.ssl_port = 5671

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

rabbitmq_vhost "/sensu" do
  action :add
end

rabbitmq_user "sensu" do
  password node.sensu.rabbitmq_password
  action :add
end

rabbitmq_user "sensu" do
  vhost "/vhost"
  permissions "\".*\" \".*\" \".*\""
  action :set_permissions
end

if node.sensu.firewall
  include_recipe "iptables"

  iptables_rule "port_rabbitmq"
end
