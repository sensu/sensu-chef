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

def enable_sensu_runsvdir
  log "sensu_embedded_runit_deprecated" do
    message 'sensu.init_style "runit" is deprecated and will be removed in version 4.0 of this cookbook'
    level :warn
  end

  execute "configure_sensu_runsvdir_#{new_resource.service}" do
    command "#{sensu_ctl} configure"
    not_if "#{sensu_ctl} configured?"
  end

  # Keep on trying till the job is found :(
  execute "wait_for_sensu_runsvdir_#{new_resource.service}" do
    command "#{sensu_ctl} configured?"
    not_if "#{sensu_ctl} configured?"
    retries 30
  end
end

def load_current_resource
  @sensu_svc = run_context.resource_collection.lookup("service[#{new_resource.service}]") rescue nil
  @sensu_svc ||= case new_resource.init_style
  when "sysv"
    service_provider = case node["platform_family"]
    when /aix/
      Chef::Provider::Service::Aix
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
      retries 3
      retry_delay 5
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
      retries 3
      retry_delay 5
      action :nothing
      subscribes :restart, resources("ruby_block[sensu_service_trigger]"), :delayed
    end
  end
end

action :enable do
  case new_resource.init_style
  when "sysv"
    @sensu_svc.run_action(:enable)
    new_resource.updated_by_last_action(@sensu_svc.updated_by_last_action?)
  when "runit"
    enable_sensu_runsvdir

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

    enable_svc = execute "sensu-ctl_#{new_resource.service}_enable" do
      command "#{sensu_ctl} #{new_resource.service} enable"
      not_if { sensu_runit_service_enabled? }
      notifies :create, "ruby_block[block_until_runsv_#{new_resource.service}_available]", :immediately
    end

    init_path = "/etc/init.d/#{new_resource.service}"

    file init_path do
      action :delete
      only_if { sensu_runit_service_enabled? && !::File.symlink?(init_path) }
    end

    svc_link = link init_path do
      to "#{sensu_path}/embedded/bin/sv"
    end

    if enable_svc.updated_by_last_action? or svc_link.updated_by_last_action?
      new_resource.updated_by_last_action(true)
    end
  end
end

action :disable do
  case new_resource.init_style
  when "sysv"
    @sensu_svc.run_action(:disable)
    new_resource.updated_by_last_action(@sensu_svc.updated_by_last_action?)
  when "runit"
    disable_svc = execute "sensu-ctl_#{new_resource.service}_disable" do
      command "#{sensu_ctl} #{new_resource.service} disable"
      only_if { sensu_runit_service_enabled? }
    end

    new_resource.updated_by_last_action(disable_svc.updated_by_last_action?)
  end
end

action :start do
  @sensu_svc.run_action(:start)
  new_resource.updated_by_last_action(@sensu_svc.updated_by_last_action?)
end

action :stop do
  @sensu_svc.run_action(:stop)
  new_resource.updated_by_last_action(@sensu_svc.updated_by_last_action?)
end

action :restart do
  @sensu_svc.run_action(:restart)
  new_resource.updated_by_last_action(@sensu_svc.updated_by_last_action?)
end
