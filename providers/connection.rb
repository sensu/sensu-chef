action :create do
  definition = {
    new_resource.name => new_resource.to_hash.select { |key, value|
      %w[host port user password ssl].include? key
    }
  }

  json_file ::File.join(node.sensu.directory, "conf.d", "connections", "#{new_resource.name}.json") do
    content definition
    mode 0644
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end

action :delete do
  file ::File.join(node.sensu.directory, "conf.d", "connections", "#{new_resource.name}.json") do
    action :delete
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end
