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
    # Sensu service action trigger for LWRP's
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
when "fedora"
  include_recipe "yum"

  # the sensu yum repo uses rhel versioning to segment builds, so we need to map
  # fedora versions to the closest rhel version here.
  # based on: http://en.wikipedia.org/wiki/Red_Hat_Enterprise_Linux#Relationship_to_free_and_community_distributions
  rhel_version_equivalent = case node.platform_version.to_i
  when 6..11  then 5
  when 12..18 then 6
  # TODO: 18+ will map to rhel7 but we don't have sensu builds for that yet
  else
    raise "I don't know how to map fedora version #{node['platform_version']} to a RHEL version. aborting"
  end

  yum_repository "sensu" do
    repo = node.sensu.package.unstable ? "yum-unstable" : "yum"
    url "http://repos.sensuapp.org/#{repo}/el/#{rhel_version_equivalent}/$basearch/"
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

ssl_directory = File.join(node.sensu.directory, "ssl")
cert_chain_file = File.join(ssl_directory, "cert.pem")
private_key_file = File.join(ssl_directory, "key.pem")

directory ssl_directory

ssl = data_bag_item("sensu", "ssl")

file node.sensu.rabbitmq.ssl.cert_chain_file do
  content ssl["client"]["cert"]
  mode 0644
end

file node.sensu.rabbitmq.ssl.private_key_file do
  content ssl["client"]["key"]
  mode 0644
end

unless node.sensu.rabbitmq_hostname.empty?
  rabbitmq_hostname = node.sensu.rabbitmq_hostname
else
  rabbitmq_node = search(:node, "recipe:[sensu::rabbitmq]").first

  rabbitmq_hostname = if rabbitmq_node.has_key?("cloud")
    rabbitmq_node["cloud"]["public_hostname"] || rabbitmq_node["hostname"]
  else
    rabbitmq_node["hostname"]
  end
end

sensu_connection "rabbitmq" do
  host rabbitmq_hostname
  port 5671
  ssl(
    "cert_chain_file" => cert_chain_file,
    "private_key_file" => private_key_file
  )
  vhost "/sensu"
  user "sensu"
  password node.sensu.rabbitmq_password
end
