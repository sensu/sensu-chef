#
# Cookbook Name:: sensu
# Recipe:: dashboard
#
# Copyright 2011, Sonian Inc.
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

service "sensu-dashboard" do
  provider node.platform =~ /ubuntu|debian/ ? Chef::Provider::Service::Init::Debian : Chef::Provider::Service::Init::Redhat
  action [:enable, :start]
  subscribes :restart, resources(:sensu_config => node.name), :delayed
end

if node.sensu.dashboard.redirect_port_80
  include_recipe "iptables"

  redirect_command = "iptables -t nat -A PREROUTING -p tcp -j REDIRECT"
  redirect_command << " --dport 80 --to-ports #{node.sensu.dashboard.port}"
  redirect_command << " -m comment --comment 'Sensu Dashboard Redirect'"

  execute "redirect_port_80_to_#{node.sensu.dashboard.port}" do
    command redirect_command
    not_if "iptables -L -t nat | grep 'Sensu Dashboard Redirect'"
  end
end

if node.sensu.firewall
  include_recipe "iptables"

  iptables_rule "port_sensu-dashboard" do
    variables :port => node.sensu.dashboard.redirect_port_80 ? 80 : node.sensu.dashboard.port
  end
end
