action :create do
  definitions = Sensu::Helpers.select_attributes(
    node.sensu,
    %w[rabbitmq redis api]
  )

  config = Sensu::Helpers.data_bag_item(node['sensu']["config_data_bag_key"], true, node['sensu']['data_bag_name'])

  if config
    definitions = Chef::Mixin::DeepMerge.merge(definitions, config.to_hash)
  end

  service_config = {}

  %w[
    client
    api
    server
  ].each do |service|
    next unless node.recipe?("sensu::#{service}_service")

    service_data_bag_item = Sensu::Helpers.data_bag_item(service, true, node['sensu']['data_bag_name'])

    if service_data_bag_item
      service_config = Chef::Mixin::DeepMerge.merge(service_config, service_data_bag_item.to_hash)
    end
  end

  unless service_config.empty?
    definitions = Chef::Mixin::DeepMerge.merge(definitions, service_config)
  end

  f = sensu_json_file ::File.join(node.sensu.directory, "config.json") do
    content Sensu::Helpers.sanitize(definitions)
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
