action :create do
  definition = {
    "mutators" => {
      new_resource.name => {
        "command" => new_resource.command
      }
    }
  }

  mutators_directory = File.join(node.sensu.directory, "conf.d", "mutators")

  directory mutators_directory do
    recursive true
    mode 0755
  end

  sensu_json_file File.join(mutators_directory, "#{new_resource.name}.json") do
    mode 0644
    content definition
  end
end

action :delete do
  sensu_json_file File.join(node.sensu.directory, "conf.d", "mutators", "#{new_resource.name}.json") do
    action :delete
  end
end
