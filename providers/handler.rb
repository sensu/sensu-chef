def load_current_resource
  definition_directory = ::File.join(node.sensu.directory, "conf.d", "handlers")
  @definition_file = ::File.join(definition_directory, "#{new_resource.name}.json")
end

action :create do
  handler = Sensu::Helpers.select_attributes(
    new_resource,
    %w[type filters mutator severities handlers command socket exchange]
  ).merge(new_resource.additional)

  definition = {
    "handlers" => {
      new_resource.name => Sensu::Helpers.sanitize(handler)
    }
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
