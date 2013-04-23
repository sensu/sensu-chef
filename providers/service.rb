def sensu_ctl
  "/opt/sensu/bin/sensu-ctl"
end

def service_pipe
  "/opt/sensu/sv/#{new_resource.name}/supervise/ok"
end

def service_path
  "/opt/sensu/sv/service/#{new_resource.name}"
end

def load_current_resource
  @service_enabled = ::File.symlink?(service_path) && ::FileTest.pipe?(service_pipe)
end

action :enable do
  case new_resource.init_style
  when "sysv"
    service new_resource.name do
      provider node.platform_family =~ /debian/ ? Chef::Provider::Service::Init::Debian : Chef::Provider::Service::Init::Redhat
      supports :status => true, :restart => true
      action [:enable, :start]
      subscribes :restart, resources("ruby_block[sensu_service_trigger]"), :delayed
    end
  when "runit"
    ruby_block "block_until_runsv_#{new_resource.name}_available" do
      block do
        Chef::Log.debug("waiting until named pipe #{service_pipe} exists")
        until ::FileTest.pipe?(service_pipe)
          sleep(1)
          Chef::Log.debug(".")
        end
      end
      action :nothing
    end

    execute "sensu-ctl_#{new_resource.name}_enable" do
      command "#{sensu_ctl} #{new_resource.name} enable"
      not_if { @service_enabled }
      notifies :create, "ruby_block[block_until_runsv_#{new_resource.name}_available]", :immediately
    end

    service new_resource.name do
      start_command "#{sensu_ctl} sensu-api start"
      stop_command "#{sensu_ctl} sensu-api stop"
      status_command "#{sensu_ctl} sensu-api status"
      restart_command "#{sensu_ctl} sensu-api restart"
      supports :restart => true, :status => true
      action [:start]
      subscribes :restart, resources("ruby_block[sensu_service_trigger]"), :delayed
    end
  end
end

action :disable do
  case new_resource.init_style
  when "sysv"
    service new_resource.name do
      provider node.platform_family =~ /debian/ ? Chef::Provider::Service::Init::Debian : Chef::Provider::Service::Init::Redhat
      action [:disable]
    end
  when "runit"
    execute "sensu-ctl_#{new_resource.name}_disable" do
      command "#{sensu_ctl} #{new_resource.name} disable"
      only_if { @service_enabled }
    end
  end
end
