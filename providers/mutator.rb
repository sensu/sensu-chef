action :create do
  definition = {
    "mutators" => {
      new_resource.name => {
        "command" => new_resource.command
      }
    }
  }

  mutators_directory = ::File.join(node.sensu.directory, "conf.d", "mutators")

  directory mutators_directory do
    recursive true
    mode 0755
  end

  json_file ::File.join(mutators_directory, "#{new_resource.name}.json") do
    content definition
    mode 0644
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end

action :delete do
  file ::File.join(node.sensu.directory, "conf.d", "mutators", "#{new_resource.name}.json") do
    action :delete
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end
