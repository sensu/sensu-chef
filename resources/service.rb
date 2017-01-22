actions :enable, :disable, :start, :stop, :restart

attribute :service, :name_attribute => true, :kind_of => String, :required => true, :equal_to => %w[sensu-server sensu-client sensu-api sensu-enterprise]

def initialize(*args)
  super
  @action = :enable
end
