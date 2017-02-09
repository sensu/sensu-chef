#
# Cookbook Name:: sensu
# Recipe:: _linux
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

platform_family = node["platform_family"]

case platform_family
when "debian"
  include_recipe "apt"

  apt_repository "sensu" do
    uri node["sensu"]['apt_repo_url']
    key "#{node['sensu']['apt_repo_url']}/pubkey.gpg"
    distribution node["lsb"]["codename"]
    components node["sensu"]["use_unstable_repo"] ? ["unstable"] : ["main"]
    action :add
    only_if { node["sensu"]["add_repo"] }
  end

  apt_preference "sensu" do
    pin "version #{node['sensu']['version']}"
    pin_priority "700"
  end

  package_options = '--force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew"'

  package "sensu" do
    version node["sensu"]["version"]
    options package_options
    notifies :create, "ruby_block[sensu_service_trigger]"
  end
when "rhel", "fedora"
  repo = yum_repository "sensu" do
    description "sensu monitoring"
    repo = node["sensu"]["use_unstable_repo"] ? "yum-unstable" : "yum"
    baseurl "#{node['sensu']['yum_repo_url']}/#{repo}/$releasever/$basearch/"
    action :add
    only_if { node["sensu"]["add_repo"] }
  end
  repo.gpgcheck(false) if repo.respond_to?(:gpgcheck)

  # As of 0.27 we need to suffix the version string with the platform major
  # version, e.g. ".el7". Override default via node["sensu"]["version_suffix"]
  # attribute.
  yum_package "sensu" do
    version lazy { Sensu::Helpers.redhat_version_string(
      node["sensu"]["version"],
      node["platform_version"],
      node["sensu"]["version_suffix"]
    )}
    allow_downgrade true
    notifies :create, "ruby_block[sensu_service_trigger]"
  end
else
  raise "Unsupported Linux platform family #{platform_family}"
end

template "/etc/default/sensu" do
  source "sensu.default.erb"
  notifies :create, "ruby_block[sensu_service_trigger]"
end
