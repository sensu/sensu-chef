actions :create, :delete

attribute :attributes, :kind_of => Hash, :required => true
attribute :negate, :kind_of => [TrueClass, FalseClass]

def initialize(*args)
  super
  @action = :create
end
