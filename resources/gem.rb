actions :install, :upgrade, :remove

attribute :version, :kind_of => String
attribute :source,  :kind_of => String
attribute :options, :kind_of => [String, Hash]

def initialize(*args)
  super
  @action = :install
end
