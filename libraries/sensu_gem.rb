class Chef::Resource::SensuGem < Chef::Resource::GemPackage
  def initialize(name, run_context=nil)
    super
    @resource_name = :sensu_gem
    @provider = Chef::Provider::Package::Rubygems
  end

  def gem_binary
    if(::File.exists?('/opt/sensu/embedded/bin/gem'))
      '/opt/sensu/embedded/bin/gem'
    else
      'gem'
    end
  end

  def after_created
    Array(@action).each do |action|
      self.run_action(action)
    end
    Gem.clear_paths
  end
end
