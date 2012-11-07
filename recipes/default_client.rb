sensu_client node.fqdn do
  address node.ipaddress
  subscriptions ['sensu-client']
end