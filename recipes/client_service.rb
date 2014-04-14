#
# Cookbook Name:: sensu
# Recipe:: client_service
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

if !node[:sensu].attribute?(:rabbitmq) or !node[:sensu][:rabbitmq].attribute?(:host)
    Chef::Application.fatal!("RabbitMQ Host not provided, service will error out on start.  Please provide a node[:rabbitmq][:host]")
end

sensu_service "sensu-client" do
  init_style node.sensu.init_style
  action [:enable, :start]
end
