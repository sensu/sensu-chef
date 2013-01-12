action :create do
  check = new_resource.to_hash.reject { |key, value|
    !%w[type command subscribers standalone handlers].include?(key.to_s)
  }.merge({ "interval" => new_resource.interval, "refresh" => new_resource.refresh })

  definition = {
    "checks" => {
      new_resource.name => check.merge(new_resource.additional)
    }
  }

  checks_directory = ::File.join(node.sensu.directory, "conf.d", "checks")

  directory checks_directory do
    recursive true
    mode 0755
  end

  json_file ::File.join(checks_directory, "#{new_resource.name}.json") do
    content definition
    mode 0644
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end

action :delete do
  file ::File.join(node.sensu.directory, "conf.d", "checks", "#{new_resource.name}.json") do
    action :delete
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end
