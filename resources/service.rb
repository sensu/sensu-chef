actions :enable, :disable, :start, :stop, :restart
default_action :enable

attribute :service, :name_attribute => true, :kind_of => String, :required => true, :equal_to => %w[sensu-server sensu-client sensu-api sensu-enterprise]
