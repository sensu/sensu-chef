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
    JSON.pretty_generate(
      Chef::Mixin::DeepMerge.merge(
        Chef::Mixin::DeepMerge.merge(
          node_config, client_config
        ),
        databag_config
      )
    )
  end
end
