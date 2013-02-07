action :create do
  definition = {
    "handlers" => {
      new_resource.name => new_resource.to_hash.reject { |key, value|
        !%w[type filters mutator severities handlers command socket exchange].include?(key.to_s) || value.nil?
      }.merge(new_resource.additional)
    }
  }

  handlers_directory = File.join(node.sensu.directory, "conf.d", "handlers")

  directory handlers_directory do
    recursive true
    mode 0755
  end

  sensu_json_file File.join(handlers_directory, "#{new_resource.name}.json") do
    mode 0644
    content definition
  end
end

action :delete do
  sensu_json_file File.join(node.sensu.directory, "conf.d", "handlers", "#{new_resource.name}.json") do
    action :delete
  end
end
