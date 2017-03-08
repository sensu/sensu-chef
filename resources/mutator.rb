actions :create, :delete
default_action :create

attribute :command, :kind_of => String, :required => true
attribute :timeout, :kind_of => Integer
