actions :create

attribute :name, :kind_of => String
attribute :host, :kind_of => String
attribute :port, :kind_of => Integer
attribute :user, :kind_of => String
attribute :password, :kind_of => String
attribute :ssl, :kind_of => Hash

def initialize(*args)
  super
  @action = :create
end
