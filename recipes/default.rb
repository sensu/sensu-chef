#
# Cookbook Name:: sensu
# Recipe:: default
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

ruby_block "sensu_service_trigger" do
  block do
    # Sensu service restart trigger for LWRP's
  end
  action :nothing
end

package_options = ""

case node.platform
when "ubuntu", "debian"
  package_options = '--force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'

  include_recipe "apt"

  apt_repository "sensu" do
    uri "http://repos.sensuapp.org/apt"
    key "http://repos.sensuapp.org/apt/pubkey.gpg"
    distribution "sensu"
    components node.sensu.package.unstable ? ["unstable"] : ["main"]
    action :add
  end
when "centos", "redhat"
  include_recipe "yum"

  yum_repository "sensu" do
    repo = node.sensu.package.unstable ? "yum-unstable" : "yum"
    url "http://repos.sensuapp.org/#{repo}/el/#{node['platform_version'].to_i}/$basearch/"
    action :add
  end
end

unless node.platform == "windows"
  package "sensu" do
    version node.sensu.version
    options package_options
  end
else
  gem_package "sensu" do
    version node.sensu.version.split("-").first
  end
end

directory File.join(node.sensu.directory, "conf.d") do
  recursive true
end

directory node.sensu.log.directory do
  recursive true
  owner "sensu"
  mode 0755
end

if node.sensu.sudoers
  template "/etc/sudoers.d/sensu" do
    source "sudoers.erb"
    mode 0440
  end
end

include_recipe "sensu::dependencies"

remote_directory File.join(node.sensu.directory, "plugins") do
  files_mode 0755
  files_backup false
  purge true
end

if node.sensu.ssl
  node.set.sensu.rabbitmq.ssl.cert_chain_file = File.join(node.sensu.directory, "ssl", "cert.pem")
  node.set.sensu.rabbitmq.ssl.private_key_file = File.join(node.sensu.directory, "ssl", "key.pem")

  directory File.join(node.sensu.directory, "ssl")

  ssl = data_bag_item("sensu", "ssl")

  file node.sensu.rabbitmq.ssl.cert_chain_file do
    content ssl["client"]["cert"]
    mode 0644
  end

  file node.sensu.rabbitmq.ssl.private_key_file do
    content ssl["client"]["key"]
    mode 0644
  end
else
  node.sensu.rabbitmq.delete(:ssl)
  if node.sensu.rabbitmq.port == 5671
    Chef::Log.warn("Setting Sensu RabbitMQ port to 5672 as you have disabled SSL.")
    node.set.sensu.rabbitmq.port = 5672
  end
end

sensu_config node.name do
  if node.has_key?(:cloud)
    address node.cloud.public_ipv4 || node.ipaddress
  else
    address node.ipaddress
  end
  subscriptions node.roles
  data_bag data_bag_item("sensu", "config")
end
