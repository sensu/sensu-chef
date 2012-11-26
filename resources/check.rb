actions :create, :delete

attribute :command, :kind_of => String, :required => true
attribute :subscribers, :kind_of => Array, :default => Array.new
attribute :standalone, :kind_of => [TrueClass, FalseClass], :default => false
attribute :refresh, :default => 1800
attribute :interval, :default => 60
attribute :handlers, :kind_of => Array
attribute :additional, :kind_of => Hash, :default => Hash.new

def initialize(*args)
  super
  @action = :create
end
