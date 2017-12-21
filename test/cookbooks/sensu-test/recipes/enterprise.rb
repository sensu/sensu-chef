#
# Cookbook Name:: sensu-test
# Recipe:: enterprise
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

include_recipe "logrotate"

# the attributes in this hash are populated from environment variables by test-kitchen
enterprise_hash = {
  "repository" => {
    "credentials" => {
      "user" => node['sensu_test']['enterprise_repo_user'],
      "password" => node['sensu_test']['enterprise_repo_pass']
    }
  }
}

set_sensu_state(node, "enterprise", enterprise_hash)

include_recipe "sensu::enterprise"
include_recipe "sensu::rabbitmq"
include_recipe "sensu::redis"
include_recipe "sensu::enterprise_service"

# ServerSpec dependencies
package "net-tools" if platform?("ubuntu")
