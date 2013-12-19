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

describe file("/opt/sensu/embedded/bin/ruby") do
  it { should be_file }
  it { should be_executable }
end

describe command("ps aux | grep rabbitmq-server | grep -v grep") do
  it { should return_exit_status 0 }
end

describe port(5671) do
  it { should be_listening }
end

describe command("ps aux | grep redis-server | grep -v grep") do
  it { should return_exit_status 0 }
end

describe port(6379) do
  it { should be_listening }
end
