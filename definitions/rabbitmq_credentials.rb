define :rabbitmq_credentials do
  rabbitmq_vhost params[:vhost] do
    action :add
  end

  rabbitmq_user params[:user] do
    password params[:password]
    action :add
  end

  rabbitmq_user params[:user] do
    vhost params[:vhost]
    permissions params[:permissions] || ".* .* .*"
    action :set_permissions
  end
end
