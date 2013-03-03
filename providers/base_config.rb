action :create do
  definitions = SensuDefinitions::sanitize(node.sensu.to_hash, 
                  :master_keys => %w[rabbitmq redis api dashboard],
                  :allow_empty_hash => false)

  sensu_json_file ::File.join(node.sensu.directory, "config.json") do
    mode 0644
    content definitions
  end
end