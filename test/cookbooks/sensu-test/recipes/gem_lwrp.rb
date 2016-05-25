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

cpu_checks = ::File.join(Chef::Config[:file_cache_path], 'sensu-plugins-cpu-checks.gem')

remote_file cpu_checks do
  source 'https://rubygems.org/downloads/sensu-plugins-cpu-checks-0.0.3.gem'
end

# for testing source property
sensu_gem 'sensu-plugins-cpu-checks' do
  source cpu_checks
  action :install
end

# for testing upgrade action
sensu_gem 'sensu-plugins-disk-checks' do
  version '1.1.2'
  action :upgrade
end
