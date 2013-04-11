def load_current_resource
  definition_directory = ::File.join(node.sensu.directory, "conf.d")
  @definition_file = ::File.join(definition_directory, "#{new_resource.name}.json")
end

action :create do
  definition = {
    new_resource.name => new_resource.content
  }

  sensu_json_file @definition_file do
    mode 0644
    content definition
  end
end

action :delete do
  sensu_json_file @definition_file do
    action :delete
  end
end
