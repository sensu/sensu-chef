action :create do
  client_attrs = %w[
    name
    address
    subscriptions
  ]

  # exclude these attributes from being included in client definition
  # unless they have non-default values
  %w[
    keepalive
    redact
    socket
    registration
    deregistration
  ].each do |attr|
    client_attrs << attr unless new_resource.send(attr.to_sym).empty?
  end

  {
    'keepalives' => true,
    'safe_mode' => false,
    'deregister' => false
  }.each do |attr, default_value|
    client_attrs << attr if new_resource.send(attr.to_sym) != default_value
  end

  client = Sensu::Helpers.select_attributes(
    new_resource,
    client_attrs
  ).merge(new_resource.additional)

  definition = {
    "client" => Sensu::Helpers.sanitize(client)
  }

  f = sensu_json_file ::File.join(node["sensu"]["directory"], "conf.d", "client.json") do
    content definition
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
