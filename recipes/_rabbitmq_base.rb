#
# Cookbook Name:: sensu
# Recipe:: _rabbitmq_base
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

service "restart #{node.rabbitmq.service_name}" do
  service_name node.rabbitmq.service_name
  action :nothing
  subscribes :restart, resources("template[#{node.rabbitmq.config_root}/rabbitmq.config]"), :immediately
end

rabbitmq = node.sensu.rabbitmq.to_hash

config = Sensu::Helpers.data_bag_item("config", true)

if config && config["rabbitmq"].is_a?(Hash)
  rabbitmq = Chef::Mixin::DeepMerge.merge(rabbitmq, config["rabbitmq"])
end

rabbitmq_vhost rabbitmq["vhost"] do
  action :add
end

rabbitmq_user rabbitmq["user"] do
  password rabbitmq["password"]
  action :add
end

rabbitmq_user rabbitmq["user"] do
  vhost rabbitmq["vhost"]
  permissions ".* .* .*"
  action :set_permissions
end
