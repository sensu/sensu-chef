actions :create, :delete

attribute :content, :kind_of => Hash, :required => true

def initialize(*args)
  super
  @action = :create
end
