define :sensu_silence_client, action: :create, expire: nil, payload: {} do
  if params[:action] == :create || params[:action] == :silence
    sensu_api_stash "silence/#{params[:name]}" do
      api_uri params[:api_uri]
      expire params[:expire]
      payload params[:payload]
      action :create
    end
  end

  if params[:action] == :delete || params[:action] == :unsilence
    sensu_api_stash "silence/#{params[:name]}" do
      api_uri params[:api_uri]
      action :delete
    end
  end
end
