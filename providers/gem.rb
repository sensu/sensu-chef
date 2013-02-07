action :install do
    name = @new_resource.name
    gem_version = @new_resource.version
    gem_options = @new_resource.options
    gem_package name do
      if ::File.exists?('/opt/sensu/embedded/bin/gem')
        gem_binary("/opt/sensu/embedded/bin/gem")
      else
        gem_binary("gem")
      end
      version gem_version
      options gem_options
    end
end

action :remove do
    name = @new_resource.name
    gem_version = @new_resource.version
    gem_options = @new_resource.options
    gem_package name do
      if ::File.exists?('/opt/sensu/embedded/bin/gem')
        gem_binary("/opt/sensu/embedded/bin/gem")
      else
        gem_binary("gem")
      end
      version gem_version
      options gem_options
      action :remove
    end
end