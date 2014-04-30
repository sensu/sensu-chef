def load_current_resource
  @uri = URI.parse(new_resource.name)
  definition_directory = ::File.join(node.sensu.directory, "plugins")
  filename = new_resource.filename  ? new_resource.filename : ::File.basename(@uri.path)
  @definition_path = ::File.join(definition_directory, filename)
end

action :create do
  if @uri.scheme.nil?
    cookbook = ::File.dirname(@uri.path)
    file     = ::File.basename(@uri.path)
    path     = @definition_path
    f = cookbook_file file do
      cookbook cookbook
      path path
      mode  new_resource.mode    if new_resource.mode
      owner new_resource.owner   if new_resource.owner
      group new_resource.group   if new_resource.group
      rights new_resource.rights if new_resource.rights
    end
  else
    f = remote_file @definition_path do
      source new_resource.name
      mode  new_resource.mode    if new_resource.mode
      owner new_resource.owner   if new_resource.owner
      group new_resource.group   if new_resource.group
      rights new_resource.rights if new_resource.rights
    end
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end

action :delete do
  f = file @definition_path do
    action :delete
  end

  new_resource.updated_by_last_action(f.updated_by_last_action?)
end
