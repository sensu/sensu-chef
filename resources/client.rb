actions :create

attribute :address, :kind_of => String, :required => true
attribute :subscriptions, :kind_of => Array, :default => Array.new
attribute :keepalive, :kind_of => Hash, :default => Hash.new
attribute :additional, :kind_of => Hash, :default => Hash.new

def initialize(*args)
  super
  @action = :create
end

def after_created
  unless name =~ /^[\w\.-]+$/
    raise Chef::Exceptions::ValidationFailed, "Sensu client name cannot contain spaces or special characters"
  end
end
