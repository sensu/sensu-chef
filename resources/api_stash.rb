actions :create, :delete

attribute :api_uri, :kind_of => String, :required => true
attribute :payload, :kind_of => [Hash, FalseClass], :default => Hash.new

def initialize(*args)
  super
  @action = :create
end
