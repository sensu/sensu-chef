module Sensu
  def self.generate_config(node, databag)
    address = node.has_key?(:cloud) ? node.cloud.public_ipv4 : node.ipaddress
    node_config = Mash.new(
      node.sensu.to_hash.reject{ |key, value|
        %w(id chef_type data_bag).include?(key)
      }
    )
    client_config = Mash.new(
      'client' => {
        :name => node.name,
        :address => address,
        :subscriptions => node.roles
      }
    )
    databag_config = Mash.new(
      databag.reject{ |key,value|
        %w(id chef_type data_bag).include?(key)
      }
    )
    config = Chef::Mixin::DeepMerge.merge(
      Chef::Mixin::DeepMerge.merge(
        node_config, client_config
      ),
      databag_config
    )
    JSON.pretty_generate(sort_hash(config))
  end

  def self.sort_hash(hash)
    if(hash.is_a?(Hash))
      new_hash = defined?(OrderedHash) ? OrderedHash.new : Hash.new
      hash.keys.sort.each do |key|
        new_hash[key] = case hash[key]
        when Mash
          sort_hash(hash[key].to_hash)
        when Hash
          sort_hash(hash[key])
        else
          hash[key]
        end
      end
      new_hash
    else
      hash
    end
  end
end
