action :create do
  keys = %w[rabbitmq redis api dashboard]
  definitions = Sensu::Helpers.select_attributes(
    node.sensu, keys
  )

  config = Sensu::Helpers.data_bag_item("config", true)

  if config
    definitions = Chef::Mixin::DeepMerge.merge(definitions, config)
  end

  f = sensu_json_file ::File.join(node.sensu.directory, "config.json") do
    content Sensu::Helpers.sanitize(definitions)
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
