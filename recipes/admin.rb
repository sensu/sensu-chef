#
# Cookbook Name:: sensu
# Recipe:: admin
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
# Note: This default install uses sqlite, which uses a file on the HD, if you lose this file your audit, downtime and user audits/logs will be gone.
# If this is important to you - BACK IT UP, or use a SQL DB thats already backed up for you.
#

package "nginx"
package "sqlite3"
package "libsqlite3-dev"

gem_package "unicorn"
gem_package "bundler"
gem_package "rake" do
  version "0.9.2.2"
end

directory node.sensu.admin.base_path do
  owner "sensu"
  group "sensu"
  mode '0755'
  recursive true
end

# Otherwise chef is making the child directories owned by root (under recursive true)
%w{ website
    website/shared
    website/shared/config
    website/shared/log
    website/shared/db
    website/shared/bundle
    website/shared/pids }.each do |dir|
  directory "#{node.sensu.admin.base_path}/#{dir}" do
    owner "sensu"
    group "sensu"
    mode '0755'
    recursive true
  end
end

file "/etc/nginx/sites-enabled/default" do
  action :delete
end

template "#{node.sensu.admin.base_path}/sensu-admin-unicorn.rb" do
  user "sensu"
  group "sensu"
  source "admin/sensu-admin-unicorn.rb.erb"
  variables(:workers => node.cpu.total.to_i + 1,
            :base_path => node.sensu.admin.base_path,
            :backend_port => node.sensu.admin.backend_port)
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
end

template "#{node.sensu.admin.base_path}/sensu-admin-nginx.conf" do
  user "sensu"
  group "sensu"
  source "admin/sensu-admin-nginx.conf.erb"
  variables(:host => node.sensu.admin.host,
            :base_path => node.sensu.admin.base_path,
            :http_port => node.sensu.admin.http_port,
            :https_port => node.sensu.admin.https_port,
            :backend_port => node.sensu.admin.backend_port)
  notifies :restart, resources(:service => "nginx"), :delayed
end

template "/etc/init.d/sensu-admin" do
  source "admin/unicorn.init.erb"
  owner "root"
  group "root"
  mode "0755"
  variables(:base_path => node.sensu.admin.base_path)
end

link "/etc/nginx/sites-available/sensu-admin.conf" do
  to "#{node.sensu.admin.base_path}/sensu-admin-nginx.conf"
end

link "/etc/nginx/sites-enabled/sensu-admin.conf" do
  to "/etc/nginx/sites-available/sensu-admin.conf"
end

ssl = data_bag_item("sensu", "ssl")

file "#{node.sensu.admin.base_path}/server-cert.pem" do
  content ssl["client"]["cert"]
  mode 0644
end

file "#{node.sensu.admin.base_path}/server-key.pem" do
  content ssl["client"]["key"]
  mode 0600
end

deploy_revision "sensu-admin" do
  action :deploy
  repository node.sensu.admin.repo
  revision node.sensu.admin.release
  user "sensu"
  group "sensu"
  environment "RAILS_ENV" => "production"
  deploy_to "#{node.sensu.admin.base_path}/website"
  create_dirs_before_symlink %w{tmp tmp/cache}
  purge_before_symlink %w{log}
  symlink_before_migrate "db/production.sqlite3" => "db/production.sqlite3"
  symlinks "log"=>"log"
  shallow_clone false
  enable_submodules true
  before_migrate do
    execute "bundle install --path #{node.sensu.admin.base_path}/website/shared/bundle" do
      user "root"
      cwd release_path
    end
  end
  before_symlink do
    execute "rake db:create" do
      user "sensu"
      cwd release_path
      not_if "test -f #{release_path}/db/production.sqlite3"
    end
    file "#{release_path}/db/production.sqlite3" do
      user "sensu"
      mode "0600"
      only_if "test -f #{release_path}/db/production.sqlite3"
    end
    execute "bundle exec whenever --update-crontab" do
      cwd release_path
      user "sensu"
    end
  end
  migrate true
  migration_command "bundle exec rake db:migrate --trace >/tmp/migration.log 2>&1 && bundle exec rake assets:precompile && bundle exec rake db:seed"
end

service "sensu-admin" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
