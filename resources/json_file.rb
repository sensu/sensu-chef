actions :create, :delete

attribute :path, :name_attribute => true
attribute :mode, :kind_of => [String, Integer]
attribute :content, :kind_of => Hash

def initialize(*args)
  super
  @action = :create
end
