#
# Cookbook Name:: sensu
# Recipe:: _aix
#
# Copyright 2016, Heavy Water Operations, LLC.
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

bff_path = File.join(Chef::Config[:file_cache_path], 'sensu.bff')

remote_file bff_path do
  source "#{node["sensu"]["aix_package_root_url"]}/sensu-#{node["sensu"]["version"]}.powerpc.bff"
end

package "sensu" do
  source bff_path
end

template "/etc/default/sensu" do
  source "sensu.default.erb"
  notifies :create, "ruby_block[sensu_service_trigger]"
end
