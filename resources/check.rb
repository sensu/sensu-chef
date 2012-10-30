actions :create, :delete

attribute :name, :kind_of => String
attribute :command, :kind_of => String, :required => true
attribute :subscribers, :kind_of => Array, :default => Array.new
attribute :standalone, :kind_of => [TrueClass, FalseClass], :default => false
attribute :interval, :default => 60
attribute :handlers, :kind_of => Array
attribute :additional, :kind_of => Hash, :default => Hash.new

def initialize(*args)
  super
  @action = :create
end
