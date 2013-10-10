actions :create, :delete

attribute :additional, :kind_of => Hash, :default => Hash.new
attribute :command, :kind_of => String, :required => true
attribute :dependencies, :kind_of => Array
attribute :handle, :kind_of => [TrueClass, FalseClass]
attribute :handlers, :kind_of => Array
attribute :high_flap_threshold, :kind_of => Integer
attribute :interval, :default => 60
attribute :low_flap_threshold, :kind_of => Integer
attribute :publish, :kind_of => [TrueClass, FalseClass]
attribute :refresh, :kind_of => Integer
attribute :standalone, :kind_of => [TrueClass, FalseClass]
attribute :subscribers, :kind_of => Array
attribute :timeout, :kind_of => Integer
attribute :type, :kind_of => String, :equal_to => %w[status metric]

def initialize(*args)
  super
  @action = :create
end
