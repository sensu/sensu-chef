actions :create

attribute :command, :kind_of => String, :required => true

def initialize(*args)
  super
  @action = :create
end
