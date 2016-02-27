#
# Cookbook Name:: sensu
# Recipe:: client
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

include_recipe 'sensu::default'

monitoring_ips = search(:node, node[:sensu][:role_search]).map { |n| n['ipaddress'] }

if monitoring_ips.count > 0
  node.normal[:sensu][:rabbitmq][:host] = monitoring_ips.first
else
  Chef::Application.fatal! 'no node found.'
end


sensu_client node.name do
  address node["ipaddress"]
  subscriptions node["roles"] + ["all"]
end



if node["sensu"].include?("plugin")
    node[:sensu][:plugin].each do | name, options|

        pl_type = options["type"] || "plugins"
        sensu_plugin options["url"] do
          asset_directory File.join(node.sensu.directory, pl_type)
          action :create_if_missing
        end

    end
end

if node["sensu"].include?("check")

  Dir[ ::File.join(node["sensu"]["directory"], "conf.d", "checks","*.json") ].each do |ck|
    file ck do
      action :delete
      not_if { node[:sensu][:check].include?(::File.basename(ck).gsub(".json","") ) }
      notifies :create, "ruby_block[sensu_service_trigger]"
    end
  end


    node[:sensu][:check].each do | name, options|
        sensu_check name do
          command options["command"]
          handlers options["handlers"] || ["default"]
          subscribers node["roles"] + ["all"]
          interval options["interval"]  || 300
          standalone true
         additional(
            :notification => options["notification"] || name,
            :occurrences => options["occurrences"] || 5
            )
        end
    end
end




if node["sensu"].include?("handler")

  # purge unwanted file
  Dir[ ::File.join(node["sensu"]["directory"], "conf.d", "handler","*.json") ].each do |ck|
    file ck do
      action :delete
      not_if { node[:sensu][:check].include?(::File.basename(ck).gsub(".json","") ) }
      notifies :create, "ruby_block[sensu_service_trigger]"
    end
  end

    node[:sensu][:handler].each do | name, options|
      sensu_handler name do
        type options["type"] || "pipe"
        command options["command"]
        severities options["severities"] || ["ok", "warning", "critical", "unknown"]
      end
    end
end





include_recipe "sensu::client_service"
