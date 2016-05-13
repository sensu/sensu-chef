
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
