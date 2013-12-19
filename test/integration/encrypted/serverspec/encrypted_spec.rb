require "serverspec"
require "net/http"
require "uri"

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = "/sbin:/usr/sbin"
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

describe service("sensu-dashboard") do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/sensu/config.json') do
  its(:content) { should match /encryptedPassword42/ }
end
