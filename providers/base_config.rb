action :create do
  definitions = Sensu::Helpers.select_attributes(
    node["sensu"],
    %w[transport rabbitmq redis api]
  )

  data_bag_name = node["sensu"]["data_bag"]["name"]
  config_item = node["sensu"]["data_bag"]["config_item"]

  config = Sensu::Helpers.data_bag_item(config_item, true, data_bag_name)

  if config
    definitions = Chef::Mixin::DeepMerge.merge(definitions, config.to_hash)
  end

  service_config = {}

  %w[
    client
    api
    server
  ].each do |service|
    unless node.recipe?("sensu::#{service}_service") ||
           node.recipe?("sensu::enterprise_service")
      next
    end

    service_data_bag_item = Sensu::Helpers.data_bag_item(service, true, data_bag_name)

    if service_data_bag_item
      service_config = Chef::Mixin::DeepMerge.merge(service_config, service_data_bag_item.to_hash)
    end
  end

  unless service_config.empty?
    definitions = Chef::Mixin::DeepMerge.merge(definitions, service_config)
  end

  # Sensu 0.15 added support for multiple rabbitmq brokers as an array of hashes.
  #
  # If an array of "hosts" is provided, an array of transport config hashes
  # is created using the values of port, vhost, user and password defined under
  # `sensu.rabbitmq` attributes.
  #
  # If "hosts" is empty, the value of "host" is used to construct an array containing
  # a single transport config hash, also using the values of port, vhost, user and
  # password defined under `sensu.rabbitmq` attributes.
  #
  # With this implementation, the rabbitmq configuration should always be rendered
  # as an array.
  #
  # @param definitions [Hash]
  # @param hosts [Array]
  # @return [Array] Array of rabbitmq transport configuration hashes

  def generate_rabbitmq_array(definitions, hosts)
    hosts.map do |host|
      config = { "host" => host }
      config.merge!(definitions["rabbitmq"].reject { |k| k == "host" || k == "hosts" })
    end
  end

  rabbitmq_config_array = if definitions["rabbitmq"]["hosts"].empty?
                            generate_rabbitmq_array(definitions, [definitions["rabbitmq"]["host"]])
                          else
                            generate_rabbitmq_array(definitions, definitions["rabbitmq"]["hosts"])
                          end

  definitions["rabbitmq"] = rabbitmq_config_array

  f = sensu_json_file ::File.join(node["sensu"]["directory"], "config.json") do
    content Sensu::Helpers.sanitize(definitions)
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
