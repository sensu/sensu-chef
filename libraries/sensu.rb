module Sensu
  def self.generate_config(node, databag)
    config = node.sensu.to_hash.reject { |key, value| %w[installation sandbox plugin user directory log].include?(key) }
    address = node.attribute?(:cloud) ? node.cloud.public_ipv4 : node.ipaddress
    config['client'].merge!(
      :name => node.name,
      :address => address,
      :subscriptions => node.roles
    )
    config.merge!(databag.reject { |key, value| %w[id chef_type data_bag].include?(key) })
    JSON.pretty_generate(config)
  end
end
