#
# Cookbook Name:: sensu
# Recipe:: enterprise_dashboard
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

platform_family = node["platform_family"]
platform_version = node["platform_version"].to_i

data_bag_name = node["sensu"]["data_bag"]["name"]
enterprise_item = node["sensu"]["data_bag"]["enterprise_item"]

enterprise = Sensu::Helpers.data_bag_item(enterprise_item, true, data_bag_name)

credentials = enterprise["repository"]["credentials"]

repository_url = "http://#{credentials['user']}:#{credentials['password']}@enterprise.sensuapp.com"

case platform_family
when "debian"
  include_recipe "apt"

  apt_repository "sensu-enterprise" do
    uri File.join(repository_url, "apt")
    key File.join(repository_url, "apt", "pubkey.gpg")
    distribution "sensu-enterprise"
    components node["sensu"]["enterprise"]["use_unstable_repo"] ? ["unstable"] : ["main"]
    action :add
  end
else
  repo = yum_repository "sensu-enterprise-dashboard" do
    description "sensu enterprise dashboard"
    repo = node["sensu"]["enterprise"]["use_unstable_repo"] ? "yum-unstable" : "yum"
    url "#{repository_url}/#{repo}/$basearch/"
    action :add
  end
  repo.gpgcheck(false) if repo.respond_to?(:gpgcheck)
end

package "sensu-enterprise-dashboard" do
  version node["sensu"]["enterprise-dashboard"]["version"]
end

sensu_dashboard_config node.name
