action :create do
  client = Sensu::Helpers.select_attributes(
    new_resource,
    %w[name address subscriptions keepalive]
  ).merge(new_resource.additional)

  definition = {
    "client" => Sensu::Helpers.sanitize(client)
  }

  f = sensu_json_file ::File.join(node["sensu"]["directory"], "conf.d", "client.json") do
    content definition
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
