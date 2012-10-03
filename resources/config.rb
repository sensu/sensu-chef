actions :create, :updated

attribute :address, :kind_of => String
attribute :subscriptions, :kind_of => Array
attribute :data_bag, :kind_of => String

def initialize(*args)
  super
  @action = :create
end
