action :create do
  unless Sensu::JSONFile.compare_content(new_resource.path, new_resource.content)
    directory ::File.dirname(new_resource.path) do
      recursive true
      owner new_resource.owner
      owner new_resource.group
      mode 0750
    end

    file new_resource.path do
      owner new_resource.owner
      group new_resource.group
      mode new_resource.mode
      content Sensu::JSONFile.dump_json(new_resource.content)
      notifies :create, "ruby_block[sensu_service_trigger]", :immediately
    end
  end
end

action :delete do
  file new_resource.path do
    action :delete
    notifies :create, "ruby_block[sensu_service_trigger]", :immediately
  end
end
