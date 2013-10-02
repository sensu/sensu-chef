actions :create, :delete

attribute :command, :kind_of => String, :required => true
attribute :timeout, :kind_of => Integer

def initialize(*args)
  super
  @action = :create
end
