def load_current_resource
  definition_directory = ::File.join(node.sensu.directory, "conf.d", "handlers")
  @definition_path = ::File.join(definition_directory, "#{new_resource.name}.json")
end

action :create do
  handler = Sensu::Helpers.select_attributes(
    new_resource,
    %w[
      command exchange filters handlers
      mutator severities socket timeout type 
    ]
  ).merge(new_resource.additional)

  definition = {
    "handlers" => {
      new_resource.name => Sensu::Helpers.sanitize(handler)
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
