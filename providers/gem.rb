action :install do
  gem_package new_resource.name do
    gem_binary Sensu::Helpers.gem_binary
    version new_resource.version
    options new_resource.options
  end
  new_resource.updated_by_last_action(true)
end

action :remove do
  gem_package new_resource.name do
    gem_binary Sensu::Helpers.gem_binary
    version new_resource.version
    action :remove
  end
  new_resource.updated_by_last_action(true)
end
