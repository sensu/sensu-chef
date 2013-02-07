action :create do
  definitions = node.sensu.to_hash.reject do |key, value|
    !%w[rabbitmq redis api dashboard].include?(key.to_s) || value.nil?
  end

  sensu_json_file File.join(node.sensu.directory, "config.json") do
    mode 0644
    content definitions
  end
end
