require 'serverspec'
set :backend, :exec

# These fingerprints match the statically defined credentials in
# sensu-test::run_state_helpers.rb
{
  '/etc/sensu/ssl/cert.pem' => 'e29124436dec99a0a3126f61a742605d9c3cbf77',
  '/etc/sensu/ssl/key.pem' => '43caa67add519458b1580dcc3a29b16335d49a15',
  '/etc/rabbitmq/ssl/cacert.pem' => '6e55d6674eed7baede54d3209ba5cd940573c128',
  '/etc/rabbitmq/ssl/cert.pem' => 'f5cbb4082744001ba5c7d859fd9618f9d66a3dde',
  '/etc/rabbitmq/ssl/key.pem' => '1a85b037669b3a11e53a9f7da9ae65990bd9cdc3',
  '/etc/rabbitmq/ssl/client/cert.pem' => 'e29124436dec99a0a3126f61a742605d9c3cbf77',
  '/etc/rabbitmq/ssl/client/key.pem' => '43caa67add519458b1580dcc3a29b16335d49a15'
}.each_pair do |pem, fingerprint|

  # The INVALID strings from sensu::ssl data bag item fixture should not be present.
  describe file(pem) do
    its(:content) { should_not match /INVALID/ }
  end

  # Fingerprints should match
  describe command("/usr/bin/openssl dgst -sha1 #{pem}") do
    its(:stdout) { should match fingerprint }
  end
end
