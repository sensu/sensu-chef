actions :install, :remove

default_action :install

attribute :name,    :kind_of => String, :name_attribute => true 
attribute :version, :kind_of => String, :default => nil
attribute :options, :kind_of => Hash, :default => nil

def initialize(*args)
  super
  @action = :install
end
