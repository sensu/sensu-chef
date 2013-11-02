def load_current_resource
  definition_directory = ::File.join(node.sensu.directory, "conf.d", "checks")
  @definition_path = ::File.join(definition_directory, "#{new_resource.name}.json")
end

action :create do
  # Check attributes that have defaults require merging onto `select_attributes`
  # results. Currently this is only `interval`.
  check = Sensu::Helpers.select_attributes(
    new_resource,
    %w[
      type command timeout subscribers standalone handle
      handlers publish low_flap_threshold high_flap_threshold
    ]
  ).merge("interval" => new_resource.interval).merge(new_resource.additional)

  definition = {
    "checks" => {
      new_resource.name => Sensu::Helpers.sanitize(check)
    }
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
