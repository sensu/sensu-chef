#
# Cookbook Name:: sensu
# Recipe:: cleanup
#
# Copyright 2014, Korviakov Andrey, NetBox
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

action :run do
  Chef::Log.info("#{new_resource} Disabling up unmanaged Sensu checks")

  definition_directory = ::File.join(node.sensu.directory, "conf.d", "checks")
  @definition_path = ::File.join(definition_directory, "#{new_resource.name}.json")

  file_list = ::Dir.glob(::File.join(definition_directory, '*.json'))

  protected_files = run_context.resource_collection.all_resources.select do |resource|
    resource.resource_name == "#{new_resource.cookbook_name}_check".to_sym
  end.map do |resource|
    ::File.join(definition_directory, "#{resource.name}.json")
  end

  kill_them_with_fire = file_list - protected_files

  kill_them_with_fire.each do |file|
    Chef::Log.info("Sensu check '#{file}' is not managed by Chef. Disabling it.")
    ::File.unlink file
  end

  if not kill_them_with_fire.empty?
    new_resource.updated_by_last_action(true)
  end
end

action :disable do
  Chef::Log.info("#{new_resource} is disabled. All unknown checks will be left as is!!!")
end
