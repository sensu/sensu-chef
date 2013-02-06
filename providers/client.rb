action :create do
  client = {
    "name" => new_resource.name,
    "address" => new_resource.address,
    "subscriptions" => new_resource.subscriptions
  }

  definition = {
    "client" => client.merge(new_resource.additional)
  }

  sensu_json_file ::File.join(node.sensu.directory, "conf.d", "client.json") do
    mode 0644
    content definition
  end
end
