actions :enable, :disable, :start, :stop, :restart

attribute :service, :name_attribute => true, :kind_of => String, :required => true, :equal_to => %w[sensu-server sensu-client sensu-api]
attribute :init_style, :kind_of => String, :required => true, :equal_to => %w[sysv runit]

def initialize(*args)
  super
  @action = :enable
end
