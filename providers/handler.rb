action :create do
  definition = {
    "handlers" => {
      new_resource.name => new_resource.to_hash.select { |key, value|
        %w[type command socket exchange severities handlers].include? key
      }
    }
  }

  json_file ::File.join(node.sensu.directory, "conf.d", "handlers", "#{new_resource.name}.json") do
    content definition
    mode 0644
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end

action :delete do
  file ::File.join(node.sensu.directory, "conf.d", "handlers", "#{new_resource.name}.json") do
    action :delete
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end
