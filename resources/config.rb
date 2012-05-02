actions :create, :updated

attribute :address, :kind_of => String
attribute :subscriptions, :kind_of => Array

def initialize(*args)
  super
  @action = :create
end
