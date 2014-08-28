#
# Cookbook Name:: sensu
# Recipe:: _base
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

ruby_block "sensu_service_trigger" do
  block do
    # Sensu service action trigger for LWRP's
  end
  action :nothing
end

if platform_family?("windows")
  include_recipe "sensu::_windows"
else
  include_recipe "sensu::_linux"
end

directory node.sensu.log_directory do
  owner "sensu"
  group "sensu"
  recursive true
  mode 0750
end

%w[
  conf.d
  plugins
  handlers
  extensions
].each do |dir|
  directory File.join(node.sensu.directory, dir) do
    owner node.sensu.admin_user
    group "sensu"
    recursive true
    mode 0750
  end
end
