actions :create, :delete

attribute :type, :kind_of => String, :equal_to => %w[status metric]
attribute :command, :kind_of => String, :required => true
attribute :timeout, :kind_of => Integer
attribute :subscribers, :kind_of => Array
attribute :standalone, :kind_of => [TrueClass, FalseClass]
attribute :aggregate, :kind_of => [TrueClass, FalseClass]
attribute :interval, :default => 60
attribute :handle, :kind_of => [TrueClass, FalseClass]
attribute :handlers, :kind_of => Array
attribute :publish, :kind_of => [TrueClass, FalseClass]
attribute :subdue, :kind_of => Hash
attribute :low_flap_threshold, :kind_of => Integer
attribute :high_flap_threshold, :kind_of => Integer
attribute :additional, :kind_of => Hash, :default => Hash.new

def initialize(*args)
  super
  @action = :create
end

def after_created
  unless name =~ /^[\w\.-]+$/
    raise Chef::Exceptions::ValidationFailed, "Sensu check name cannot contain spaces or special characters"
  end
end
