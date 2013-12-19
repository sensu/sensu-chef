action :create do
  keys = %w[rabbitmq redis api dashboard]
  definitions = Sensu::Helpers.select_attributes(
    node.sensu, keys
  )
  if node.sensu.use_encrypted_data_bag
    Sensu::Helpers.deep_merge!(definitions, Sensu::Helpers.select_attributes(
      Chef::EncryptedDataBagItem.load(node.sensu.data_bag_name, "secrets"), keys
    ))
  end

  # https://github.com/sensu/sensu-chef/issues/210
  #
  # The values in node.sensu are all strings -- even when explicitly defined as
  # as an int. Consider this setting from attributes/default.rb:
  #   default.sensu.rabbitmq.port = 5671
  # The expression 'node[:rabbitmq][:port].class' yields 'string' not 'integer'.
  #
  # This results in the port values in config.json having string values, which
  # in turn causes some of the services to fail to start (sensu-api in particular)
  #
  # Thus the big hack below. Maybe there is a better way. Maybe we are accessing
  # the chef attributes in some way that is causing ints to be converted to strings.
  # May we should fix the processes to themselves convert ports to ints (although
  # that would seem to be more smelly than this hack.)
  #
  definitions = Hash[definitions.map { |ko,h|
    [ko, Hash[h.map { |ki,v|
      [ki, ki == 'port' ? v.to_i : v]
    }]]
  }]

  f = sensu_json_file ::File.join(node.sensu.directory, "config.json") do
    content Sensu::Helpers.sanitize(definitions)
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
