action :create do
  sensu_service_trigger = !!run_context.resource_collection.detect do |r|
    r.to_s == "ruby_block[sensu_service_trigger]"
  end

  unless Sensu::JSONFile.compare_content(new_resource.path, new_resource.content)
    directory ::File.dirname(new_resource.path) do
      recursive true
      owner lazy { new_resource.owner || node["sensu"]["admin_user"] }
      group lazy { new_resource.group || node["sensu"]["group"] }
      mode 0750
    end

    f = file new_resource.path do
      owner lazy { new_resource.owner || node["sensu"]["admin_user"] }
      group lazy { new_resource.group || node["sensu"]["group"] }
      mode new_resource.mode
      content Sensu::JSONFile.dump_json(new_resource.content)
      notifies :create, "ruby_block[sensu_service_trigger]", :delayed if sensu_service_trigger
    end

    new_resource.updated_by_last_action(f.updated_by_last_action?)
  end
end

action :delete do
  sensu_service_trigger = !!node.run_context.resource_collection.detect do |r|
    r.to_s == "ruby_block[sensu_service_trigger]"
  end

  f = file new_resource.path do
    action :delete
    notifies :create, "ruby_block[sensu_service_trigger]", :delayed if sensu_service_trigger
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
