action :create do
  keys = %w[rabbitmq redis api dashboard]
  definitions = Sensu::Helpers.select_attributes(
    node.sensu, keys
  )
  if node.sensu.use_encrypted_data_bag
    Sensu::Helpers.deep_merge!(definitions, Sensu::Helpers.select_attributes(
      Chef::EncryptedDataBagItem.load("sensu", "secrets"), keys
    ))
  end

  f = sensu_json_file ::File.join(node.sensu.directory, "config.json") do
    content Sensu::Helpers.sanitize(definitions)
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
