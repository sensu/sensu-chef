action :create do
  definition = {
    "filters" => {
      new_resource.name => new_resource.to_hash.reject { |key, value|
        !%w[attributes negate].include?(key.to_s)
      }
    }
  }

  filters_directory = ::File.join(node.sensu.directory, "conf.d", "filters")

  directory filters_directory do
    recursive true
    mode 0755
  end

  json_file ::File.join(filters_directory, "#{new_resource.name}.json") do
    content definition
    mode 0644
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end

  notify_if_updated

end

action :delete do
  file ::File.join(node.sensu.directory, "conf.d", "filters", "#{new_resource.name}.json") do
    action :delete
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end

  notify_if_updated

end
