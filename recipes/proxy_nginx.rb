#
# Cookbook Name:: sensu
# Recipe:: proxy_nginx
#
# Copyright 2012, Kwarter Inc.
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

include_recipe 'nginx'

if node.sensu.proxy.ssl
  proxy = data_bag_item("sensu", "proxy")

  directory "#{node['nginx']['dir']}/ssl" do
    owner 'root'
    group 'root'
    mode '0755'
  end

  %w(key cert).each do |item|
    file "#{node['nginx']['dir']}/ssl/sensu.#{item}" do
      content proxy["ssl"][item]
      mode 0644
    end
  end

end

template "#{node['nginx']['dir']}/sites-available/sensu" do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables :ssl_key  => "#{node['nginx']['dir']}/ssl/sensu.key",
            :ssl_cert => "#{node['nginx']['dir']}/ssl/sensu.cert"
  notifies :reload, resources(:service => 'nginx')
end

nginx_site 'sensu' do
  enable true
end
