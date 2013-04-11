#
# Cookbook Name:: sensu
# Recipe:: redis
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

node.override.redis.config.bind = "0.0.0.0"
node.override.redis.config.port = node.sensu.redis.port

if node.platform == "ubuntu" && node.platform_version <= "10.04"
  node.override.redis.install_type = "source"
elsif node.platform == "debian"
  node.override.redis.install_type = "source"
else
  node.override.redis.install_type = "package"
end

include_recipe "redis::server"
