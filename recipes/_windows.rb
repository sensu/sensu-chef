#
# Cookbook Name:: sensu
# Recipe:: _windows
#
# Copyright 2014, Sonian Inc.
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

windows = node["sensu"]["windows"].dup

user node["sensu"]["user"] do
  password Sensu::Helpers.random_password(20, true, true, true, true)
  not_if { Sensu::Helpers.windows_user_exists?(node["sensu"]["user"]) }
end

group node["sensu"]["group"] do
  members node["sensu"]["user"]
  append true
  action :manage
end

if windows["install_dotnet"]
  include_recipe "ms_dotnet::ms_dotnet#{windows['dotnet_major_version']}"
end

package "Sensu" do
  source "#{node['sensu']['msi_repo_url']}/sensu-#{node['sensu']['version']}.msi"
  options windows["package_options"]
  version node["sensu"]["version"].tr("-", ".")
  notifies :create, "ruby_block[sensu_service_trigger]", :immediately
end

template 'C:\opt\sensu\bin\sensu-client.xml' do
  source "sensu.xml.erb"
  variables :service => "sensu-client", :name => "Sensu Client"
  notifies :create, "ruby_block[sensu_service_trigger]", :immediately
end

execute "sensu-client.exe install" do
  cwd 'C:\opt\sensu\bin'
  not_if { Sensu::Helpers.windows_service_exists?("sensu-client") }
end
