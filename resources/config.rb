actions :create, :updated

attribute :address, :kind_of => String
attribute :subscriptions, :kind_of => Array
attribute :data_bag

def initialize(*args)
  super
  @action = :create
end
