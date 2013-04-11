action :install do
  gem_package new_resource.name do
    gem_binary Sensu::Helpers.gem_binary
    version new_resource.version
    options new_resource.options
  end
end

action :remove do
  gem_package new_resource.name do
    gem_binary Sensu::Helpers.gem_binary
    version new_resource.version
    action :remove
  end
end
