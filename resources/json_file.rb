actions :create, :delete

attribute :path, :name_attribute => true
attribute :owner, :kind_of => String
attribute :group, :kind_of => String, :default => node['sensu']['group']
attribute :mode, :kind_of => [String, Integer], :default => 0640
attribute :content, :kind_of => Hash

def initialize(*args)
  super
  @action = :create
end
