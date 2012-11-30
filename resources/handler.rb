actions :create, :delete

attribute :type, :kind_of => String
attribute :command, :kind_of => String
attribute :socket, :kind_of => Hash
attribute :exchange, :kind_of => Hash
attribute :severities, :kind_of => Array
attribute :handlers, :kind_of => Array
attribute :mutator, :kind_of => String
attribute :additional, :kind_of => Hash, :default => Hash.new

def initialize(*args)
  super
  @action = :create
end
