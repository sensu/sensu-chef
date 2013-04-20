def sensu_ctl
  ::File.join(node.sensu.embedded_directory,'bin','sensu-ctl')
end

def service_pipe
  ::File.join(node.sensu.embedded_directory,'sv',new_resource.name,'supervise','ok')
end

def sensu_service_path
  ::File.join(node.sensu.embedded_directory,'service',new_resource.name)
end

def load_current_resource
  @service_enabled = ::File.symlink?(sensu_service_path) && ::FileTest.pipe?(service_pipe)
end

action :enable do
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
end

action :disable do
  execute "sensu-ctl_#{new_resource.name}_disable" do
    command "#{sensu_ctl} #{new_resource.name} disable"
    only_if { @service_enabled }
  end
end
