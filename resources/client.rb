actions :create

attribute :address, :kind_of => String, :required => true
attribute :subscriptions, :kind_of => Array, :default => Array.new
attribute :additional, :kind_of => Hash, :default => Hash.new

def initialize(*args)
  super
  @action = :create
end
