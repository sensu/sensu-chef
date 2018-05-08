actions :create, :delete
default_action :create

# 'standard' and 'status' types are synonymous
attribute :additional, :kind_of => Hash, :default => Hash.new
attribute :command, :kind_of => String, :required => true
attribute :aggregate, :kind_of => [String, TrueClass, FalseClass]
attribute :aggregates, :kind_of => Array
attribute :interval, :default => 60
attribute :handle, :kind_of => [TrueClass, FalseClass]
attribute :handlers, :kind_of => Array
attribute :high_flap_threshold, :kind_of => Integer
attribute :low_flap_threshold, :kind_of => Integer
attribute :publish, :kind_of => [TrueClass, FalseClass]
attribute :source, :kind_of => String
attribute :standalone, :kind_of => [TrueClass, FalseClass]
attribute :subdue, :kind_of => Hash
attribute :subscribers, :kind_of => Array
attribute :timeout, :kind_of => Integer
attribute :ttl, :kind_of => Integer
attribute :type, :kind_of => String, :equal_to => %w[standard status metric]

def after_created
  unless name =~ /^[\w\.-]+$/
    raise Chef::Exceptions::ValidationFailed, "Sensu check #{name}: name cannot contain spaces or special characters"
  end

  if [action].compact.flatten.include?(:create)
     raise Chef::Exceptions::ValidationFailed, "Sensu check #{name}: must either define subscribers, or has to be standalone." unless (subscribers || standalone)
  end
end
