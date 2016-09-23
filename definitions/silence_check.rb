define :sensu_silence_check, action: :create, expire: nil, payload: {} do
  params[:client] = node.name if params[:client].nil?

  if params[:action] == :create || params[:action] == :silence
    sensu_api_stash "silence/#{params[:client]}/#{params[:name]}" do
      api_uri params[:api_uri]
      expire params[:expire]
      payload params[:payload]
      action :create
    end
  end

  if params[:action] == :delete || params[:action] == :unsilence
    sensu_api_stash "silence/#{params[:client]}/#{params[:name]}" do
      api_uri params[:api_uri]
      action :delete
    end
  end
end
