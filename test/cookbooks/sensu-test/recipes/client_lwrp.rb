sensu_client 'lwrp_client' do
  address '10.0.0.1'
  subscriptions ['all']
  keepalives false
  keepalive('handler' => 'pagerduty', 'thresholds' => { 'warning' => 40, 'critical' => 60 })
  safe_mode true
  redact ['obscure_api_token_name']
  socket('bind' => '0.0.0.0', 'port' => 4040)
  registration('handler' => 'register_client')
  deregister true
  deregistration('handler' => 'deregister_client')
  additional('bacon' => true, 'beer' => {'variety' => 'cold'})
end
