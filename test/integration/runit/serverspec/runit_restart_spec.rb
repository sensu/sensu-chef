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

service = "sensu-client"

pid_file = "/opt/sensu/sv/#{service}/supervise/pid"

describe file(pid_file) do
  its(:content) { should match /^[0-9]+$/ }
end

describe command("cp #{pid_file} /tmp/_pid_file") do
  it { should return_exit_status 0 }
end

describe command("/opt/sensu/bin/sensu-ctl #{service} restart") do
  it { should return_exit_status 0 }
end

describe command("diff #{pid_file} /tmp/_pid_file") do
  it { should return_exit_status 1 }
end
