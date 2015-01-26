def load_current_resource
  @current_resource = Chef::Resource::SensuApiStash.new(new_resource.name)
  @current_resource.api_uri(new_resource.api_uri)
  api = Sensu::API::Stash.new(@current_resource.api_uri)
  @current_resource.payload(api.get("/stashes/#{@current_resource.name}"))
end

action :create do
  api = Sensu::API::Stash.new(new_resource.api_uri)
  unless new_resource.payload == @current_resource.payload
    # add path, timestamp and owner to the payload
    # when we look at the stash later, these bits helps us know how old a stash is and how it got there
    # allow to overwrite payload completely
    payload = {'path' => new_resource.name, 'content' => { 'timestamp' => Time.now.to_i, 'owner' => 'chef'}}

    if new_resource.expire != nil
      payload['expire'] = new_resource.expire
    end

    merged_payload = payload.merge(new_resource.payload)
    if api.post("/stashes", merged_payload)
      new_resource.updated_by_last_action(true)
    end
  end
end

action :delete do
  api = Sensu::API::Stash.new(new_resource.api_uri)
  unless @current_resource.payload == false
    if api.delete("/stashes/#{new_resource.name}")
      new_resource.updated_by_last_action(true)
    end
  end
end
