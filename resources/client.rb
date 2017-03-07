actions :create
default_action :create

attribute :address, :kind_of => String, :required => true
attribute :subscriptions, :kind_of => Array, :default => []
attribute :keepalive, :kind_of => Hash, :default => {}
attribute :keepalives, :kind_of => [TrueClass, FalseClass], :default => true
attribute :safe_mode, :kind_of => [TrueClass, FalseClass], :default => false
attribute :redact, :kind_of => Array, :default => []
attribute :socket, :kind_of => Hash, :default => {}
attribute :registration, :kind_of => Hash, :default => {}
attribute :deregister, :kind_of => [TrueClass, FalseClass], :default => false
attribute :deregistration, :kind_of => Hash, :default => {}
attribute :additional, :kind_of => Hash, :default => {}

def after_created
  raise Chef::Exceptions::ValidationFailed, "Sensu client name cannot contain spaces or special characters" unless name =~ /^[\w\.-]+$/
end
