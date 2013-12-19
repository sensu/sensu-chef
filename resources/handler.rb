actions :create, :delete

attribute :additional, :kind_of => Hash, :default => Hash.new
attribute :command, :kind_of => String
attribute :exchange, :kind_of => Hash
attribute :filters, :kind_of => Array
attribute :handlers, :kind_of => Array
attribute :mutator, :kind_of => String
attribute :severities, :kind_of => Array
attribute :socket, :kind_of => Hash
attribute :timeout, :kind_of => Integer
attribute :type, :kind_of => String, :equal_to => %w[set pipe tcp udp amqp]

def initialize(*args)
  super
  @action = :create
end
