def load_current_resource
  definition_directory = ::File.join(node["sensu"]["directory"], "conf.d", "checks")
  @definition_path = ::File.join(definition_directory, "#{new_resource.name}.json")
end

action :create do

  if new_resource.type == 'status'
    Chef::Log.warn("sensu_check[#{new_resource.name}]: type 'status' is deprecated and will be removed in a future version. Please use type 'standard' instead.")
  end

  # Check attributes that have defaults require merging onto `select_attributes`
  # results. Currently this is only `interval`.
  check = Sensu::Helpers.select_attributes(
    new_resource,
    %w[
      type command timeout subscribers standalone aggregate aggregates handle
      handlers publish subdue low_flap_threshold high_flap_threshold
    ]
  ).merge("interval" => new_resource.interval).merge(new_resource.additional)

  definition = {
    "checks" => {
      new_resource.name => Sensu::Helpers.sanitize(check)
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
