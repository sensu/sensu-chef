def load_current_resource
  @owner = new_resource.owner || node["sensu"]["admin_user"]

  @uri = URI.parse(new_resource.name)

  asset_directory = case
  when new_resource.asset_directory
    new_resource.asset_directory
  when new_resource.path
    ::File.dirname(new_resource.path)
  else
    ::File.dirname(@uri.path)
  end

  @file_name = case
  when new_resource.path
    ::File.basename(new_resource.path)
  else
    ::File.basename(@uri.path)
  end

  @asset_path = ::File.join(asset_directory, @file_name)
end

def manage_sensu_asset(resource_action)
  if @uri.scheme.nil?
    local_source = case
    when new_resource.source_directory
      ::File.join(new_resource.source_directory, @file_name)
    else
      new_resource.source
    end

    f = cookbook_file @asset_path do
      cookbook new_resource.cookbook
      source local_source
      mode  new_resource.mode
      owner @owner
      group new_resource.group
      rights new_resource.rights if new_resource.rights
      action resource_action
    end
  else
    f = remote_file @asset_path do
      source new_resource.name
      checksum new_resource.checksum
      mode  new_resource.mode
      owner @owner
      group new_resource.group
      rights new_resource.rights if new_resource.rights
      action resource_action
    end
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end

[
 :create,
 :create_if_missing,
 :delete
].each do |resource_action|
  action resource_action do
    manage_sensu_asset(resource_action)
  end
end
