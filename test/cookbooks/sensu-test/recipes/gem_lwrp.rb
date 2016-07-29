include_recipe 'build-essential' unless platform?('windows')

# specify resource without action for testing default action == :install
sensu_gem 'sensu-plugins-sensu'

# explicitly specify :install action for additional tests
sensu_gem 'sensu-plugins-slack' do
  action :install
end

# ensure we pass the specified version
sensu_gem 'sensu-plugins-chef' do
  version '0.0.5'
  action :install
end

# for testing remove action
sensu_gem 'sensu-plugins-hipchat' do
  action :remove
end

mem_checks = ::File.join(Chef::Config[:file_cache_path], 'sensu-plugins-memory-checks.gem')

remote_file mem_checks do
  source 'https://rubygems.org/downloads/sensu-plugins-memory-checks-1.0.2.gem'
end

# for testing source property
sensu_gem 'sensu-plugins-memory-checks' do
  source mem_checks
  action :install
end

# for testing upgrade action
sensu_gem 'sensu-plugins-disk-checks' do
  version '1.1.2'
  action :upgrade
end
