actions :create, :delete
default_action :create

# 'standard' and 'status' types are synonymous
attribute :additional, :kind_of => Hash, :default => Hash.new
attribute :command, :kind_of => String, :required => true
attribute :aggregate, :kind_of => [String, TrueClass, FalseClass]
attribute :aggregates, :kind_of => Array
attribute :interval, :kind_of => [Integer, FalseClass], :default=> 60
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
attribute :cron, :kind_of => [String, FalseClass], :default => false

def after_created
  unless name =~ /^[\w\.-]+$/
    raise Chef::Exceptions::ValidationFailed, "Sensu check #{name}: name cannot contain spaces or special characters"
  end

  if cron.is_a?(String) && interval.is_a?(Integer)
    raise Chef::Exceptions::ValidationFailed, "Sensu check #{name}: must either define interval, or cron, not both."
  end

  if !cron && !interval
    raise Chef::Exceptions::ValidationFailed, "Sensu check #{name}: must either define interval, or cron, currently both set to 'false' which means both are ignored."
  end

  if interval.is_a?(Integer) && !interval.positive?
    raise Chef::Exceptions::ValidationFailed, "Sensu check #{name}: itnerval must be a positive number"
  end

  if [action].compact.flatten.include?(:create)
     raise Chef::Exceptions::ValidationFailed, "Sensu check #{name}: must either define subscribers, or has to be standalone." unless (subscribers || standalone)
  end
end
