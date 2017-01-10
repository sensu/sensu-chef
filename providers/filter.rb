def load_current_resource
  definition_directory = ::File.join(node["sensu"]["directory"], "conf.d", "filters")
  @definition_path = ::File.join(definition_directory, "#{new_resource.name}.json")
end

action :create do
  filter = Sensu::Helpers.select_attributes(
    new_resource,
    %w(attributes negate days)
  )
  if filter.keys.map(&:to_s).include?('days')
    filter[:when] = { :days => (filter.delete(:days) || filter.delete('days')) }
  end

  definition = {
    "filters" => {
      new_resource.name => Sensu::Helpers.sanitize(filter)
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
