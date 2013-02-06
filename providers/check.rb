action :create do
  check = new_resource.to_hash.reject { |key, value|
    !%w[type command subscribers standalone handlers].include?(key.to_s) || value.nil?
  }.merge("interval" => new_resource.interval)

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

  sensu_json_file ::File.join(checks_directory, "#{new_resource.name}.json") do
    mode 0644
    content definition
  end
end

action :delete do
  sensu_json_file ::File.join(node.sensu.directory, "conf.d", "checks", "#{new_resource.name}.json") do
    action :delete
  end
end
