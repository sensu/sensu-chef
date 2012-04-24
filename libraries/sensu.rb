module Sensu
  def self.generate_config(node, databag)
    attributes_config = node.sensu.to_hash.reject do |key, value|
      %w[plugin directory log sudoers firewall].include?(key)
    end
    databag_config = databag.reject do |key, value|
      %w[id chef_type data_bag].include?(key)
    end
    address = node.has_key?(:cloud) ? node.cloud.public_ipv4 : node.ipaddress
    client_config = {
      :client => {
        :name => node.name,
        :address => address,
        :subscriptions => node.roles
      }
    }
    config = Chef::Mixin::DeepMerge.merge(
      Chef::Mixin::DeepMerge.merge(
        attributes_config,
        databag_config
      ),
      client_config
    )
    JSON.pretty_generate(sort_hash(config))
  end

  def self.sort_hash(old_hash)
    if old_hash.is_a?(Hash)
      new_hash = defined?(OrderedHash) ? OrderedHash.new : Hash.new
      old_hash.keys.sort.each do |key|
        new_hash[key] = case old_hash[key]
        when Mash
          sort_hash(old_hash[key].to_hash)
        when Hash
          sort_hash(old_hash[key])
        when Array
          old_hash[key].sort
        else
          old_hash[key]
        end
      end
      new_hash
    else
      old_hash
    end
  end
end
