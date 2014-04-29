def load_current_resource
  definition_directory = ::File.join(node.sensu.directory, "plugins")
  @definition_path = ::File.join(definition_directory, filename)
end

def filename
  if new_resource.filename
    new_resource.filename
  elsif new_resource.name.include? "::"
    new_resource.name.split("::").last
  else
    ::File.basename(URI.parse(new_resource.name).path)
  end
end

action :create do
  if new_resource.name.include? "::"
    cookbook, file = new_resource.name.split("::")
    path = @definition_path
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
