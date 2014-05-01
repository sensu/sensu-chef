actions :create, :delete

attribute :source,             :kind_of => String, :name_attribute => true
attribute :filename,           :kind_of => String
attribute :cookbook_directory, :kind_of => String
attribute :mode,               :kind_of => String, :default => '0755'
attribute :owner,              :kind_of => String
attribute :group,              :kind_of => String, :default => 'sensu'
attribute :rights,             :kind_of => String

def initialize(*args)
  super
  @action = :create
end
