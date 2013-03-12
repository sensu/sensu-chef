define :sensu_silence_check, :action => :create, :payload => {} do

  if params[:client].nil?
    params[:client] = node.name
  end

  if params[:action] == :create or params[:action] == :silence
    # add a timestamp and owner to the payload
    # when we look at the stash later, these bits helps us know how old a stash is and how it got there
    merged_payload = params[:payload].merge({'timestamp' => Time.now.to_i, 'owner' => 'chef'})

    sensu_api_stash "silence/#{params[:client]}/#{params[:name]}" do
      api_uri params[:api_uri]
      payload merged_payload
      action :create
    end
  end

  if params[:action] == :delete or params[:action] == :unsilence
    sensu_api_stash "silence/#{params[:client]}/#{params[:name]}" do
      api_uri params[:api_uri]
      action :delete
    end
  end
end
