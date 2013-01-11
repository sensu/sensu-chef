actions :create, :delete

attribute :payload, :kind_of => [Hash,FalseClass], :default => {}
attribute :api_uri, :kind_of => String, :required => true

def initialize(*args)
  super
  @action = :create
end
