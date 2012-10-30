action :create do
  definition = {
    "checks" => {
      new_resource.name => new_resource.to_hash.select { |key, value|
        %w[command subscribers standalone interval handlers].include?(key)
      }.merge(new_resource.additional)
    }
  }

  json_file ::File.join(node.sensu.directory, "conf.d", "checks", "#{new_resource.name}.json") do
    content definition
    mode 0644
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end

action :delete do
  file ::File.join(node.sensu.directory, "conf.d", "checks", "#{new_resource.name}.json") do
    action :delete
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end
