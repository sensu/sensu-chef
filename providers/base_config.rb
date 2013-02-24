action :create do
  definitions = node.sensu.to_hash.reject do |key, value|
    !%w[rabbitmq redis api dashboard].include?(key.to_s) || value.nil?
  end

  def clean_config(config_value)
    if config_value.is_a?(Hash)
      clean_hash = Hash.new
      config_value.each do |key, value|
        new_value = clean_config(value)
        clean_hash[key] = new_value unless new_value.nil?
      end
      clean_hash.empty? ? nil : clean_hash
    else
      config_value
    end
  end

  definitions = clean_config(definitions)

  sensu_json_file ::File.join(node.sensu.directory, "config.json") do
    mode 0644
    content definitions
  end
end
