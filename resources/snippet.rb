actions :create, :delete

attribute :content, :required => true

def initialize(*args)
  super
  @action = :create
end
