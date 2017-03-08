actions :install, :upgrade, :remove
default_action :install

attribute :version, :kind_of => String
attribute :source,  :kind_of => String
attribute :options, :kind_of => [String, Hash]
