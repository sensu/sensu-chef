#
# Cookbook Name:: sensu
# Recipe:: dashboard_service
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

service "sensu-dashboard" do
  provider node.platform =~ /ubuntu|debian/ ? Chef::Provider::Service::Init::Debian : Chef::Provider::Service::Init::Redhat
  supports :status => true, :restart => true
  action [:enable, :start]
  subscribes :restart, resources("ruby_block[sensu_service_trigger]"), :delayed
end
