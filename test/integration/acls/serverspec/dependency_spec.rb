require "serverspec"
require "net/http"
require "uri"

set :backend, :exec
set :path, "/bin:/usr/bin:/sbin:/usr/sbin"

describe file("/opt/sensu/embedded/bin/ruby") do
  it { should be_file }
  it { should be_executable }
end

describe command("ps aux | grep rabbitmq-server | grep -v grep") do
  its(:exit_status) { should eq 0 }
end

describe port(5671) do
  it { should be_listening }
end

describe command("ps aux | grep redis-server | grep -v grep") do
  its(:exit_status) { should eq 0 }
end

describe port(6379) do
  it { should be_listening }
end
