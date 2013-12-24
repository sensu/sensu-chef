#
# Cookbook Name:: sensu
# Recipe:: _linux
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

package_options = ""

case node.platform_family
when "debian"
  package_options = '--force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew"'

  include_recipe "apt"

  apt_repository "sensu" do
    uri node.sensu.apt_repo_url
    key "#{node.sensu.apt_repo_url}/pubkey.gpg"
    distribution "sensu"
    components node.sensu.use_unstable_repo ? ["unstable"] : ["main"]
    action :add
  end

  apt_preference "sensu" do
    pin "version #{node.sensu.version}"
    pin_priority "700"
  end
when "rhel"
  include_recipe "yum"

  repo = yum_repository "sensu" do
    description "sensu monitoring"
    repo = node.sensu.use_unstable_repo ? "yum-unstable" : "yum"
    url "#{node.sensu.yum_repo_url}/#{repo}/el/#{node['platform_version'].to_i}/$basearch/"
    action :add
  end
  repo.gpgcheck(false) if repo.respond_to?(:gpgcheck)
when "fedora"
  include_recipe "yum"

  rhel_version_equivalent = case node.platform_version.to_i
  when 6..11  then 5
  when 12..18 then 6
  # TODO: 18+ will map to rhel7 but we don't have sensu builds for that yet
  else
    raise "I don't know how to map fedora version #{node['platform_version']} to a RHEL version. aborting"
  end

  repo = yum_repository "sensu" do
    description "sensu monitoring"
    repo = node.sensu.use_unstable_repo ? "yum-unstable" : "yum"
    url "#{node.sensu.yum_repo_url}/#{repo}/el/#{rhel_version_equivalent}/$basearch/"
    action :add
  end
  repo.gpgcheck(false) if repo.respond_to?(:gpgcheck)
end

package "sensu" do
  version node.sensu.version
  options package_options
  notifies :create, "ruby_block[sensu_service_trigger]"
end

template "/etc/default/sensu" do
  source "sensu.default.erb"
  notifies :create, "ruby_block[sensu_service_trigger]"
end
