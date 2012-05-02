action :create do
  attributes_config = node.sensu.to_hash.reject do |key, value|
    %w[plugin directory log ssl sudoers firewall].include?(key)
  end
  databag_config = databag.reject do |key, value|
    %w[id chef_type data_bag].include?(key)
  end
  client_config = {
    :client => {
      :name => @new_resource.name,
      :address => @new_resource.address,
      :subscriptions => @new_resource.subscriptions.sort,
    }
  }
  config_resource = @new_resource
  json_file ::File.join(node.sensu.directory, "config.json") do
    content config
    mode 0644
    notifies :updated, config_resource
  end
end

action :updated do
  @new_resource.updated_by_last_action(true)
end
