module Sensu
  module ChefRunState

    # Initialize 'sensu' in node.run_state hash
    #
    # @param node [Chef::Node] node object to mutate
    def init_sensu_state(node)
      node.run_state["sensu"] ||= Mash.new
    end

    # Get value at given path
    #
    # @param node [Chef::Node] node object to mutate
    # @param keys [String, Symbol] key path to walk
    def get_sensu_state(node, *keys)
      init_sensu_state(node)
      keys.inject(node.run_state["sensu"]) do |memo,  key|
        if memo.is_a?(Hash) && Mash.new(memo).has_key?(key.to_s)
          memo[key]
        else
          nil
        end
      end
    end

    # Set value at given path
    #
    # @param args [Chef::Node, String, Symbol, Object] node object to mutate
    # @return [Object] value set
    def set_sensu_state(*args)
      node = args.shift

      unless node.is_a?(Chef::Node)
        raise ArgumentError.new 'Set requires a Chef::Node object as the first argument'
      end

      init_sensu_state(node)

      unless args.size > 1
        raise ArgumentError.new 'Set requires at least one key/value pair'
      end

      value = args.pop

      # turn data bag items into hashes, stripping "headers" common to all data bag items
      bag_item_headers = %w( id chef_type )
      real_value = value.is_a?(Chef::DataBagItem) ? value.to_hash.reject { |k,v| bag_item_headers.include?(k) } : value

      set_key = args.pop
      leaf = args.inject(node.run_state["sensu"]) do |memo, key|
        unless memo[key].is_a?(Hash)
          memo[key] = Mash.new
        end
        memo[key]
      end
      leaf[set_key] = real_value
      real_value
    end

  end
end

Chef::Recipe.send(:include, Sensu::ChefRunState) if defined?(Chef::Recipe)
Chef::Provider.send(:include, Sensu::ChefRunState) if defined?(Chef::Provider)
Chef::Resource.send(:include, Sensu::ChefRunState) if defined?(Chef::Resource)
