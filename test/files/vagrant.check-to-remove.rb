$script = <<SCRIPT
mkdir -p /etc/sensu/conf.d/checks
echo '{"checks": {"check_to_be_removed": { "command": "true", "subscribers": [ "all" ], "interval": 20 } } }' > /etc/sensu/conf.d/checks/check_to_be_removed.json
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.provision 'shell', inline: $script, privileged: true
end
