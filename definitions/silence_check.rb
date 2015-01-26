define :sensu_silence_check, :action => :create, :expire => nil, :payload => {} do

  if params[:client].nil?
    params[:client] = node.name
  end

  if params[:action] == :create or params[:action] == :silence
    sensu_api_stash "silence/#{params[:client]}/#{params[:name]}" do
      api_uri params[:api_uri]
      expire params[:expire]
      payload params[:payload]
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
