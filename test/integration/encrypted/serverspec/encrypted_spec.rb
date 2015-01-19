require "serverspec"
require "net/http"
require "uri"

set :backend, :exec
set :path, "/bin:/usr/bin:/sbin:/usr/sbin"

describe service("sensu-server") do
  it { should be_enabled }
  it { should be_running }
end

describe service("sensu-client") do
  it { should be_enabled }
  it { should be_running }
end

describe service("sensu-api") do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/sensu/config.json') do
  its(:content) { should match /encryptedPassword42/ }
end
