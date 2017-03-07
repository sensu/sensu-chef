actions :create, :create_if_missing, :delete
default_action :create

attribute :asset_directory,    :kind_of => String
attribute :cookbook,           :kind_of => String
attribute :source,             :kind_of => String, :name_attribute => true
attribute :source_directory,   :kind_of => String
attribute :checksum,           :kind_of => String
attribute :path,               :kind_of => String
attribute :mode,               :kind_of => String, :default => '0755'
attribute :owner,              :kind_of => String
attribute :group,              :kind_of => String, :default => 'sensu'
attribute :rights,             :kind_of => String
