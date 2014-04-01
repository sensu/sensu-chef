# vim: set ts=2 sw=2 expandtab :
# encoding: UTF-8
#
# Cookbook Name:: sensu
# Library:: matchers
#
# Licensed Materials - Property of IBM
#
# (c) Copyright IBM Corp. 2014 All Rights Reserved
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#

# Matcher for Sensu community cookbook.

if defined?(ChefSpec)
  def create_sensu_api_stash(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_api_stash, :create, resource_name)
  end
  
  def delete_sensu_api_stash(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_api_stash, :delete, resource_name)
  end

  def create_sensu_base_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_base_config, :create, resource_name)
  end
    
  def create_sensu_check(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_check, :create, resource_name)
  end
  
  def delete_sensu_check(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_check, :delete, resource_name)
  end
  
  def create_sensu_client(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_client, :create, resource_name)
  end
  
  def create_sensu_filter(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_filter, :create, resource_name)
  end
  
  def delete_sensu_filter(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_filter, :delete, resource_name)
  end
  
  def install_sensu_gem(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_gem, :install, resource_name)
  end
  
  def remove_sensu_gem(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_gem, :remove, resource_name)
  end
  
  def create_sensu_handler(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_handler, :create, resource_name)
  end
  
  def delete_sensu_handler(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_handler, :delete, resource_name)
  end
  
  def create_sensu_json_file(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_json_file, :create, resource_name)
  end
  
  def delete_sensu_json_file(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_json_file, :delete, resource_name)
  end
  
  def create_sensu_mutator(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_mutator, :create, resource_name)
  end
  
  def delete_sensu_mutator(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_mutator, :delete, resource_name)
  end
  
  def enable_sensu_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_service, :enable, resource_name)
  end
  
  def disable_sensu_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_service, :disable, resource_name)
  end
  
  def start_sensu_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_service, :start, resource_name)
  end
  
  def stop_sensu_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_service, :stop, resource_name)
  end
  
  def restart_sensu_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_service, :restart, resource_name)
  end
  
  def create_sensu_snippet(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_snippet, :create, resource_name)
  end
  
  def delete_sensu_snippet(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sensu_snippet, :delete, resource_name)
  end
end
