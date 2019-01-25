actions :create, :delete
default_action :create

attribute :content, :required => true
attribute :sensitive, :kind_of => [TrueClass, FalseClass], :default => true
