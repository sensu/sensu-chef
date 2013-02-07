action :create do
  definition = {
    new_resource.name => new_resource.content
  }

  sensu_json_file ::File.join(node.sensu.directory, "conf.d", "#{new_resource.name}.json") do
    mode 0644
    content definition
  end
end

action :delete do
  sensu_json_file ::File.join(node.sensu.directory, "conf.d", "#{new_resource.name}.json") do
    action :delete
  end
end
