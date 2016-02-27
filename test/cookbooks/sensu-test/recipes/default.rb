#
# Cookbook Name:: sensu-test
# Recipe:: default
#
# Copyright 2013, Sonian, Inc.
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

include_recipe "logrotate"

include_recipe "chef-vault"

include_recipe "sensu::default"

sensu_client node.name do
  address node["ipaddress"]
  subscriptions ["all"]
end

sensu_check "test" do
  command "true"
  interval 10
  subscribers ["all"]
end

include_recipe "sensu::rabbitmq"
include_recipe "sensu::redis"
include_recipe "sensu::server_service"
include_recipe "sensu::api_service"
include_recipe "sensu::client_service"

# ServerSpec dependencies

if platform?("ubuntu")
  package "net-tools"
end

include_recipe "sensu-test::gem_lwrp"
