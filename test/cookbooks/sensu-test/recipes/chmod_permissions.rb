directory '/tmp/foo/specifications' do
  owner 'root'
  group 'root'
  mode 0o755
  recursive true
  action :create
end

directory '/tmp/foo/bin' do
  owner 'root'
  group 'root'
  mode 0o755
  recursive true
  action :create
end

file '/tmp/foo/specifications/bar.gemspec' do
  owner 'root'
  group 'root'
  mode 0o755
  action :create
end

file '/tmp/foo/bin/bar.rb' do
  owner 'root'
  group 'root'
  mode 0o755
  action :create_if_missing
end

::Chef::Recipe.send(:include, Sensu::Helpers)

# Sensu::Helpers.chmod_files('/tmp/foo/specifications/*.gemspec', 644)
# Sensu::Helpers.chmod_files('/tmp/foo/**/*.rb', 644)
