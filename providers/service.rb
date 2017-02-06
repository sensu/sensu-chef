def sensu_path
  "/opt/sensu"
end

def load_current_resource
  @sensu_svc = run_context.resource_collection.lookup("service[#{new_resource.service}]") rescue nil
  @sensu_svc ||= service new_resource.service do
    supports :status => true, :restart => true
    retries 3
    retry_delay 5
    action :nothing
    subscribes :restart, resources("ruby_block[sensu_service_trigger]"), :delayed
  end
end

action :enable do
  @sensu_svc.run_action(:enable)
  new_resource.updated_by_last_action(@sensu_svc.updated_by_last_action?)
end

action :disable do
  @sensu_svc.run_action(:disable)
  new_resource.updated_by_last_action(@sensu_svc.updated_by_last_action?)
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
