module Sensu
  def self.generate_config(node, databag)
    address = node.has_key?(:ec2) ? node.ec2.public_ipv4 : node.ipaddress
    node_config = Mash.new(
      node.sensu.to_hash.reject{ |key, value|
        %w(user version).include?(key)
      }
    )
    client_config = Mash.new(
      'client' => {
        :name => node.name,
        :address => address,
        :subscriptions =>  [
          node.roles,
          node.recipes,
          node.tags,
          node.chef_environment
        ].flatten.uniq
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

  def self.find_bin(service)
    bin_path = "/usr/bin/sensu-#{service}"
    ENV['PATH'].split(':').each do |path|
      test_path = File.join(path, "sensu-#{service}")
      if File.exists?(test_path)
        bin_path = test_path
      end
    end
    bin_path
  end
end
