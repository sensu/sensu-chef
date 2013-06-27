def load_current_resource
  definition_directory = ::File.join(node.sensu.directory, "conf.d", "mutators")
  @definition_path = ::File.join(definition_directory, "#{new_resource.name}.json")
end

action :create do
  mutator = Sensu::Helpers.select_attributes(
    new_resource,
    %w[command]
  )

  definition = {
    "mutators" => {
      new_resource.name => Sensu::Helpers.sanitize(mutator)
    }
  }

  sensu_json_file @definition_path do
    content definition
  end
end

action :delete do
  sensu_json_file @definition_path do
    action :delete
  end
end
