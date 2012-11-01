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
    Gem.clear_paths
    Array(@action).each do |action|
      self.run_action(action)
    end
    Gem.clear_paths
  end
end

# fix chef_gem
current_version = Gem::Version.new(Chef::VERSION)

if(current_version >= Gem::Version.new('10.10.0') && current_version < Gem::Version.new('10.14.0'))
  module Chef3164
    def after_created(*)
      Gem.clear_paths
      super
    end
  end

  Chef::Resource::ChefGem.send(:include, Chef3164)
end
