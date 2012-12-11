action :create do
  definition = {
    "handlers" => {
      new_resource.name => new_resource.to_hash.reject { |key, value|
        !%w[type filters mutator severities handlers command socket exchange].include?(key.to_s)
      }.merge(new_resource.additional)
    }
  }

  handlers_directory = ::File.join(node.sensu.directory, "conf.d", "handlers")

  directory handlers_directory do
    recursive true
    mode 0755
  end

  json_file ::File.join(handlers_directory, "#{new_resource.name}.json") do
    content definition
    mode 0644
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end

  notify_if_updated

end

action :delete do
  file ::File.join(node.sensu.directory, "conf.d", "handlers", "#{new_resource.name}.json") do
    action :delete
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end

  notify_if_updated

end
