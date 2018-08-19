sensu_check "valid_standalone_check" do
  interval 20
  command 'true'
  standalone true
end

sensu_check "valid_pubsub_check" do
  interval 20
  command 'true'
  subscribers ['all']
end

sensu_check "removed_check" do
  action :delete
end

# proxy client
sensu_check "valid_proxy_client_check" do
  interval 20
  command 'true'
  standalone true
  source 'some-site-being-monitored'
  ttl 40
end


sensu_check "valid_cron_check" do
  interval false
  cron '* * * * *'
  command 'true'
  subscribers ['all']
end


sensu_check "valid_check_with_default_interval" do
  command 'true'
  subscribers ['all']
end