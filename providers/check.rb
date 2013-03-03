action :create do
  check = SensuDefinitions.sanitize(new_resource.to_hash, 
            :master_keys => %w[type command subscribers standalone handlers]).
              merge("interval" => new_resource.interval).
                merge(new_resource.additional)

  definition = {
    "checks" => {
      new_resource.name => check
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
