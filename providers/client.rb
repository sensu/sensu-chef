action :create do
  definition = {
    "client" => new_resource.to_hash.select { |key, value|
      %w[name address subscriptions].include?(key)
    }.merge(new_resource.additional)
  }

  json_file ::File.join(node.sensu.directory, "conf.d", "client.json") do
    content definition
    mode 0644
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end
