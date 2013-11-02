def load_current_resource
  definition_directory = ::File.join(node.sensu.directory, "conf.d")
  @definition_path = ::File.join(definition_directory, "#{new_resource.name}.json")
end

action :create do
  definition = {
    new_resource.name => new_resource.content
  }

  sensu_json_file @definition_path do
    content definition
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  sensu_json_file @definition_path do
    action :delete
  end
  new_resource.updated_by_last_action(true)
end
