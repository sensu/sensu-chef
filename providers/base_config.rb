action :create do
  type = new_resource.type
  definitions = node.sensu.to_hash.reject do |key, value|
    if type == 'client'
      !%w{rabbitmq}.include?(key.to_s) || value.nil?
    else
      !%w[rabbitmq redis api dashboard].include?(key.to_s) || value.nil?
    end
  end
  sensu_json_file ::File.join(node.sensu.directory, "config.json") do
    mode 0644
    content definitions
  end
end
