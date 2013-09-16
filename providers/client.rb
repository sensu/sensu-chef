action :create do
  client = Sensu::Helpers.select_attributes(
    new_resource,
    %w[name address keepalive subscriptions]
  ).merge(new_resource.additional)

  definition = {
    "client" => Sensu::Helpers.sanitize(client)
  }

  sensu_json_file ::File.join(node.sensu.directory, "conf.d", "client.json") do
    content definition
  end
end
