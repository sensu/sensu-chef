actions :create, :delete
default_action :create

attribute :path, :name_attribute => true
# owner and group attributes have defaults set in the provider
attribute :owner, :kind_of => String
attribute :group, :kind_of => String
attribute :mode, :kind_of => [String, Integer], :default => 0640
attribute :content, :kind_of => Hash
