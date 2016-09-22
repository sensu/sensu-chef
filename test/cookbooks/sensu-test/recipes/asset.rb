#
# Cookbook Name:: sensu-test
# Recipe:: asset
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

include_recipe "sensu::default"

sensu_plugin "https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-http/master/bin/check-http.rb"

sensu_plugin "https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-haproxy/master/bin/check-haproxy.rb" do
  action :create_if_missing
end

sensu_plugin "check-banner.rb"

sensu_plugin "check-socket.rb" do
  source "check-banner.rb"
end

sensu_plugin "check-dns.rb" do
  source_directory "plugins"
end

sensu_plugin "https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-pagerduty/master/bin/handler-pagerduty.rb" do
  asset_directory File.join(node.sensu.directory, "handlers")
end

profiler_extension = case platform?('windows')
                     when true
                        "https://raw.githubusercontent.com/sensu/sensu-community-plugins/36ffb8b92c69065e7e5351a8011497e2c4ffd0e1/extensions/checks/wmi_metrics.rb"
                     when false
                       "https://raw.githubusercontent.com/sensu/sensu-community-plugins/36ffb8b92c69065e7e5351a8011497e2c4ffd0e1/extensions/checks/system_profile.rb"
                     end

sensu_asset profiler_extension do
  asset_directory File.join(node.sensu.directory, "extensions")
end

# adding a simple plugin gem here so we can test gem installation on windows
# without dealing with the chefspec-oriented gem_lwrp recipe
sensu_gem 'sensu-plugins-pushover'
