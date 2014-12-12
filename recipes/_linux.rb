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

package_options = ""

platform_family = node.platform_family
platform_version = node.platform_version.to_i

case platform_family
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
else
  rhel_version_equivalent = case platform_family
  when "rhel"
    if platform?("amazon") || platform_version >= 7
      6
    else
      platform_version
    end
  when "fedora"
    case platform_version
    when 6..11 then 5
    when 12..18 then 6
    else
      raise "Cannot map fedora version #{platform_version} to a RHEL version. aborting"
    end
  else
    raise "Unsupported Linux platform family #{platform_family}"
  end

  repo = yum_repository "sensu" do
    description "sensu monitoring"
    repo = node.sensu.use_unstable_repo ? "yum-unstable" : "yum"
    url "#{node.sensu.yum_repo_url}/#{repo}/el/#{rhel_version_equivalent}/$basearch/"
    action :add
  end
  repo.gpgcheck(false) if repo.respond_to?(:gpgcheck)
end

case platform_family
when "debian"
  package "sensu" do
    version node.sensu.version
    options package_options
    notifies :create, "ruby_block[sensu_service_trigger]"
  end
else
  yum_package "sensu" do
    version node.sensu.version
    options package_options
    allow_downgrade true
    notifies :create, "ruby_block[sensu_service_trigger]"
  end
end

template "/etc/default/sensu" do
  source "sensu.default.erb"
  notifies :create, "ruby_block[sensu_service_trigger]"
end
