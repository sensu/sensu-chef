action :create do
  definitions = Sensu::Helpers.select_attributes(
    new_resource,
    %w[rabbitmq redis api dashboard]
  )

  sensu_json_file ::File.join(node.sensu.directory, "config.json") do
    mode 0644
    content Sensu::Helpers.sanitize(definitions)
  end
end
