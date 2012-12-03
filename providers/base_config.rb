action :create do
  definitions = node.sensu.to_hash.reject do |key, value|
    !%w[rabbitmq redis api dashboard].include?(key)
  end

  json_file ::File.join(node.sensu.directory, "config.json") do
    content definitions
    mode 0644
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end
