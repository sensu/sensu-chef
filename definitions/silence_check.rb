define :sensu_silence_check, :action => :create, :expire => nil, :payload => {} do

  if params[:client].nil?
    params[:client] = node.name
  end

  if params[:action] == :create or params[:action] == :silence
    sensu_api_stash "silence/#{params[:client]}/#{params[:name]}" do
      api_uri params[:api_uri]
      expire params[:expire]
      payload params[:payload]
      ignore_failure params[:ignore_failure]
      action :create
    end
  end

  if params[:action] == :delete or params[:action] == :unsilence
    sensu_api_stash "silence/#{params[:client]}/#{params[:name]}" do
      api_uri params[:api_uri]
      ignore_failure params[:ignore_failure]
      action :delete
    end
  end
end
