action :create do
  client = {
    "name" => new_resource.name,
    "address" => new_resource.address,
    "subscriptions" => new_resource.subscriptions
  }

  definition = {
    "client" => client.merge(new_resource.additional)
  }

  json_file ::File.join(node.sensu.directory, "conf.d", "client.json") do
    content definition
    mode 0644
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end

  notify_if_updated

end
