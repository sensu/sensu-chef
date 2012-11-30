action :create do
  definition = {
    "mutators" => {
      new_resource.name => new_resource.to_hash.select { |key, value|
        %w[command].include?(key.to_s)
      }
    }
  }

  mutators_directory = ::File.join(node.sensu.directory, "conf.d", "mutators")

  directory mutators_directory do
    recursive true
    mode 0755
  end

  json_file ::File.join(mutators_directory, "#{new_resource.name}.json") do
    content definition
    mode 0644
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end
