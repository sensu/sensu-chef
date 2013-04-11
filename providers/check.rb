def load_current_resource
  @definition_directory = ::File.join(node.sensu.directory, "conf.d", "checks")
  @definition_file = ::File.join(@definition_directory, "#{new_resource.name}.json")
end

action :create do
  check = Sensu::Helpers.select_attributes(
    new_resource,
    %w[type command subscribers standalone handlers]
  ).merge("interval" => new_resource.interval).merge(new_resource.additional)

  definition = {
    "checks" => {
      new_resource.name => Sensu::Helpers.sanitize(check)
    }
  }

  directory @definition_directory do
    recursive true
    mode 0755
  end

  sensu_json_file @definition_file do
    mode 0644
    content definition
  end
end

action :delete do
  sensu_json_file @definition_file do
    action :delete
  end
end
