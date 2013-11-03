action :create do
  definitions = Sensu::Helpers.select_attributes(
    node.sensu,
    %w[rabbitmq redis api dashboard]
  )

  f = sensu_json_file ::File.join(node.sensu.directory, "config.json") do
    content Sensu::Helpers.sanitize(definitions)
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
