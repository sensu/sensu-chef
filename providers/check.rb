def load_current_resource
  definition_directory = ::File.join(node.sensu.directory, "conf.d", "checks")
  @definition_path = ::File.join(definition_directory, "#{new_resource.name}.json")
end

action :create do
  check = Sensu::Helpers.select_attributes(
    new_resource,
    %w[type command subscribers standalone handle handlers occurrences]
  ).merge("interval" => new_resource.interval).merge(new_resource.additional)

  definition = {
    "checks" => {
      new_resource.name => Sensu::Helpers.sanitize(check)
    }
  }

  sensu_json_file @definition_path do
    mode 0644
    content definition
  end
end

action :delete do
  sensu_json_file @definition_path do
    action :delete
  end
end
