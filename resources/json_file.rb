actions :create, :delete

attribute :content, :kind_of => Hash
attribute :group, :kind_of => String, :default => 'sensu'
attribute :mode, :kind_of => [String, Integer], :default => 0640
attribute :owner, :kind_of => String, :default => 'root'
attribute :path, :name_attribute => true

def initialize(*args)
  super
  @action = :create
end
