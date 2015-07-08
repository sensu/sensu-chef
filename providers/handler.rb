def load_current_resource
  definition_directory = ::File.join(node["sensu"]["directory"], "conf.d", "handlers")
  @definition_path = ::File.join(definition_directory, "#{new_resource.name}.json")
end

action :create do
  handler = Sensu::Helpers.select_attributes(
    new_resource,
    %w[
      type filters mutator severities handlers
      command timeout socket pipe
    ]
  ).merge(new_resource.additional)

  definition = {
    "handlers" => {
      new_resource.name => Sensu::Helpers.sanitize(handler)
    }
  }

  f = sensu_json_file @definition_path do
    content definition
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end

action :delete do
  f = sensu_json_file @definition_path do
    action :delete
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
