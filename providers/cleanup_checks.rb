action :run do
  Chef::Log.info "any checks in #{new_resource.path} that are not managed by chef will be removed"

  file_list = ::Dir.glob(::File.join(new_resource.path, '*.json'))

  protected_files = []
  run_context.resource_collection.all_resources.select do |resource|
    if resource.resource_name.to_s.include? 'sensu_check'
      protected_files << ::File.join(new_resource.path, "#{resource.name}.json")
    end
  end

  Chef::Log.info "Protected Files: #{protected_files}"

  checks_to_remove = file_list - protected_files

  checks_to_remove.each do |f|
    Chef::Log.info("Sensu check '#{f}' is not managed by Chef. Removing it.")
    file f do
      action :delete
    end
  end

  new_resource.updated_by_last_action(true) unless checks_to_remove.empty?
end

action :disable do
  Chef::Log.info("all checks in #{new_resource.path} will be left as is!!!!")
end
