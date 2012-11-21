action :create do
  snippet_directory = ::File.join(node.sensu.directory, "conf.d")

  directory snippet_directory do
    recursive true
    mode 0755
  end

  json_file ::File.join(snippet_directory, "#{new_resource.name}.json") do
    content new_resource.content
    mode 0644
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end

action :delete do
  file ::File.join(node.sensu.directory, "conf.d", "#{new_resource.name}.json") do
    action :delete
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end
