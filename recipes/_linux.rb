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

package_options = case node.platform_family
when "debian"
  package_options = '--force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
else
  ""
end

unless node.sensu.use_existing_repo
  case node.platform_family
  when "debian"
    include_recipe "apt"

    apt_repository "sensu" do
      uri "http://repos.sensuapp.org/apt"
      key "http://repos.sensuapp.org/apt/pubkey.gpg"
      distribution "sensu"
      components node.sensu.use_unstable_repo ? ["unstable"] : ["main"]
      action :add
    end
  when "rhel", "fedora"
    include_recipe "yum"

    rhel_version = if node.platform_family == 'rhel'
      node.platform_version.to_i
    else
      # the sensu yum repo uses rhel versioning to segment builds, so we need to map
      # fedora versions to the closest rhel version here.
      # based on: http://en.wikipedia.org/wiki/Red_Hat_Enterprise_Linux#Relationship_to_free_and_community_distributions
      case node.platform_version.to_i
      when 6..11  then 5
      when 12..18 then 6
      # TODO: 18+ will map to rhel7 but we don't have sensu builds for that yet
      else
        raise "I don't know how to map fedora version #{node['platform_version']} to a RHEL version. aborting"
      end
    end

    yum_repository "sensu" do
      repo = node.sensu.use_unstable_repo ? "yum-unstable" : "yum"
      url "http://repos.sensuapp.org/#{repo}/el/#{rhel_version}/$basearch/"
      action :add
    end
  end
end

package "sensu" do
  version node.sensu.version
  options package_options
end

template "/etc/default/sensu" do
  source "sensu.default.erb"
end
