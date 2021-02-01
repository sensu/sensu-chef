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

remote_file '/tmp/sensu_1.4.2-4_amd64.deb' do
  source 'https://ds-sensu-core-pkgs.s3-us-west-2.amazonaws.com/sensu_1.4.2-4_amd64.deb'
  owner 'root'
  group 'root'
  mode '0744'
  action :create
end

dpkg_package 'sensu-client' do
  source '/tmp/sensu_1.4.2-4_amd64.deb'
  action :install
  not_if { ::File.exist?('/opt/sensu/bin/sensu-client') }
end

template "/etc/default/sensu" do
  source "sensu.default.erb"
  notifies :create, "ruby_block[sensu_service_trigger]"
end
