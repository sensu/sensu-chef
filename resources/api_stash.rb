actions :create, :delete
default_action :create

attribute :api_uri, :kind_of => String, :required => true
attribute :payload, :kind_of => [Hash, FalseClass], :default => Hash.new
attribute :expire, :kind_of => Integer, :default => nil
