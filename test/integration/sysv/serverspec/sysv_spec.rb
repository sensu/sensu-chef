require "serverspec"
require "net/http"
require "uri"

set :backend, :exec

RSpec.configure do |c|
  c.before :all do
    c.path = "/bin:/sbin:/usr/sbin:/usr/bin"
  end
end

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
