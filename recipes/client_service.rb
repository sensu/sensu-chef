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

service_action = [:enable, :start]

case node.platform_family
when /windows/
  service_provider = Chef::Provider::Service::Windows
  service_action = [:start]
when /debian/
  service_provider = Chef::Provider::Service::Init::Debian
else
  service_provider = Chef::Provider::Service::Init::Redhat
end

service "sensu-client" do
  provider service_provider
  supports :status => true, :restart => true
  action service_action
  subscribes :restart, resources("ruby_block[sensu_service_trigger]"), :delayed
end
