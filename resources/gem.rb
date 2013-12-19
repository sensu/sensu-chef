actions :install, :remove

attribute :options, :kind_of => [String, Hash]
attribute :version, :kind_of => String

def initialize(*args)
  super
  @action = :install
end
