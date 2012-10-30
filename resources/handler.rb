actions :create, :delete

attribute :name, :kind_of => String
attribute :type, :kind_of => String
attribute :command, :kind_of => String
attribute :socket, :kind_of => Hash
attribute :exchange, :kind_of => Hash
attribute :severities, :kind_of => Array
attribute :handlers, :kind_of => Array

def initialize(*args)
  super
  @action = :create
end
