action :install do
  gem_package new_resource.name do
    if File.exists?("/opt/sensu/embedded/bin/gem")
      gem_binary "/opt/sensu/embedded/bin/gem"
    else
      gem_binary "gem"
    end
    version new_resource.version
    options new_resource.options
  end
end

action :remove do
  gem_package new_resource.name do
    if File.exists?("/opt/sensu/embedded/bin/gem")
      gem_binary "/opt/sensu/embedded/bin/gem"
    else
      gem_binary "gem"
    end
    version new_resource.version
    action :remove
  end
end
