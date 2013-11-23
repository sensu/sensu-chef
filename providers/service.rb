def sensu_path
  "/opt/sensu"
end

def sensu_ctl
  "#{sensu_path}/bin/sensu-ctl"
end

def sensu_service_pipe
  "#{sensu_path}/sv/#{new_resource.service}/supervise/ok"
end

def sensu_service_path
  "#{sensu_path}/service/#{new_resource.service}"
end

def sensu_runit_service_enabled?
  ::File.symlink?(sensu_service_path) && ::FileTest.pipe?(sensu_service_pipe)
end

def load_current_resource
  case new_resource.init_style
  when "sysv"
    service_provider = case node.platform_family
    when /debian/
      Chef::Provider::Service::Init::Debian
    when /windows/
      Chef::Provider::Service::Windows
    else
      Chef::Provider::Service::Init::Redhat
    end

    service new_resource.service do
      provider service_provider
      supports :status => true, :restart => true
      action :nothing
      subscribes :restart, resources("ruby_block[sensu_service_trigger]"), :delayed
    end
  when "runit"
    service new_resource.service do
      start_command "#{sensu_ctl} #{new_resource.service} start"
      stop_command "#{sensu_ctl} #{new_resource.service} stop"
      status_command "#{sensu_ctl} #{new_resource.service} status"
      restart_command "#{sensu_ctl} #{new_resource.service} restart"
      supports :restart => true, :status => true
      action :nothing
      subscribes :restart, resources("ruby_block[sensu_service_trigger]"), :delayed
    end
  end
end

action :enable do
  case new_resource.init_style
  when "sysv"
    svc = service new_resource.service do
      action :enable
    end

    new_resource.updated_by_last_action(svc.updated_by_last_action?)
  when "runit"
    ruby_block "block_until_runsv_#{new_resource.service}_available" do
      block do
        Chef::Log.debug("waiting until named pipe #{sensu_service_pipe} exists")
        until ::FileTest.pipe?(sensu_service_pipe)
          sleep(1)
          Chef::Log.debug(".")
        end
      end
      action :nothing
    end

    svc = execute "sensu-ctl_#{new_resource.service}_enable" do
      command "#{sensu_ctl} #{new_resource.service} enable"
      not_if { sensu_runit_service_enabled? }
      notifies :create, "ruby_block[block_until_runsv_#{new_resource.service}_available]", :immediately
    end

    new_resource.updated_by_last_action(svc.updated_by_last_action?)
  end
end

action :disable do
  case new_resource.init_style
  when "sysv"
    svc = service new_resource.service do
      action :disable
    end

    new_resource.updated_by_last_action(svc.updated_by_last_action?)
  when "runit"
    svc = execute "sensu-ctl_#{new_resource.service}_disable" do
      command "#{sensu_ctl} #{new_resource.service} disable"
      only_if { sensu_runit_service_enabled? }
    end

    new_resource.updated_by_last_action(svc.updated_by_last_action?)
  end
end

action :start do
  svc = service new_resource.service do
    action :start
  end

  new_resource.updated_by_last_action(svc.updated_by_last_action?)
end

action :stop do
  svc = service new_resource.service do
    action :stop
  end

  new_resource.updated_by_last_action(svc.updated_by_last_action?)
end

action :restart do
  svc = service new_resource.service do
    action :restart
  end

  new_resource.updated_by_last_action(svc.updated_by_last_action?)
end
