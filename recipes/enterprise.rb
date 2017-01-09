#
# Cookbook Name:: sensu
# Recipe:: enterprise
#
# Copyright 2014, Heavy Water Operations, LLC.
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

include_recipe "sensu"
include_recipe "sensu::_enterprise_repo"

package "sensu-enterprise" do
  version node["sensu"]["enterprise"]["version"]
end

directory node["sensu"]["enterprise"]["heap_dump_path"] do
  owner node["sensu"]["user"]
  group node["sensu"]["group"]
  not_if { node["sensu"]["enterprise"]["heap_dump_path"] == "/tmp" }
end

template "/etc/default/sensu-enterprise" do
  source "sensu-enterprise.default.erb"
end
