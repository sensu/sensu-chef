define :rabbitmq_credentials do
  unless get_sensu_state(node, :rabbitmq_credentials, params[:vhost], params[:user])
    rabbitmq_vhost params[:vhost] do
      action :add
    end

    rabbitmq_user params[:user] do
      password params[:password]
      vhost params[:vhost]
      permissions params[:permissions] || ".* .* .*"
      action [:add, :set_permissions]
    end

    set_sensu_state(node, :rabbitmq_credentials, params[:vhost], params[:user], true)
  end
end
