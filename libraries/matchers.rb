if defined?(ChefSpec)
  def create_sensu_api_stash(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_api_stash, :create, name)
  end

  def delete_sensu_api_stash(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_api_stash, :delete, name)
  end

  def create_sensu_asset(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_asset, :create, name)
  end

  def create_if_missing_sensu_asset(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_asset, :create_if_missing, name)
  end

  def delete_sensu_asset(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_asset, :delete, name)
  end

  def create_sensu_base_config(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_base_config, :create, name)
  end

  def create_sensu_check(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_check, :create, name)
  end

  def delete_sensu_check(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_check, :delete, name)
  end

  def create_sensu_client(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_client, :create, name)
  end

  def create_sensu_filter(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_filter, :create, name)
  end

  def delete_sensu_filter(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_filter, :delete, name)
  end

  def install_sensu_gem(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_gem, :install, name)
  end

  def remove_sensu_gem(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_gem, :remove, name)
  end

  def create_sensu_handler(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_handler, :create, name)
  end

  def delete_sensu_handler(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_handler, :delete, name)
  end

  def create_sensu_json_file(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_json_file, :create, name)
  end

  def delete_sensu_json_file(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_json_file, :delete, name)
  end

  def create_sensu_mutator(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_mutator, :create, name)
  end

  def delete_sensu_mutator(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_mutator, :delete, name)
  end

  def create_sensu_plugin(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_plugin, :create, name)
  end

  def create_if_missing_sensu_plugin(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_plugin, :create_if_missing, name)
  end

  def delete_sensu_plugin(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_plugin, :delete, name)
  end

  def enable_sensu_service(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_service, :enable, name)
  end

  def disable_sensu_service(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_service, :disable, name)
  end

  def start_sensu_service(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_service, :start, name)
  end

  def stop_sensu_service(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_service, :stop, name)
  end

  def restart_sensu_service(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_service, :restart, name)
  end

  def create_sensu_snippet(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_snippet, :create, name)
  end

  def delete_sensu_snippet(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_snippet, :delete, name)
  end

  def create_sensu_dashboard_config(name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_dashboard_config, :create, name)
  end
end
