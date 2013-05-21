action :create do
  definitions = Sensu::Helpers.select_attributes(
    node.sensu,
    %w[rabbitmq redis api dashboard]
  )

  sensu_json_file ::File.join(node.sensu.directory, "config.json") do
    content Sensu::Helpers.sanitize(definitions)
  end
end
