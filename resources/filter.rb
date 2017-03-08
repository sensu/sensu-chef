actions :create, :delete
default_action :create

attribute :attributes, :kind_of => Hash, :required => true
attribute :negate, :kind_of => [TrueClass, FalseClass]
attribute :days, :kind_of => Hash
