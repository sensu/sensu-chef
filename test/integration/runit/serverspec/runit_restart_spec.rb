require "serverspec"
require "net/http"
require "uri"

set :backend, :exec
set :path, "/bin:/usr/bin:/sbin:/usr/sbin"

service = "sensu-client"

pid_file = "/opt/sensu/sv/#{service}/supervise/pid"

describe file(pid_file) do
  its(:content) { should match /^[0-9]+$/ }
end

describe command("cp #{pid_file} /tmp/_pid_file") do
  its(:exit_status) { should eq 0 }
end

describe command("/opt/sensu/bin/sensu-ctl #{service} restart") do
  its(:exit_status) { should eq 0 }
end

describe command("diff #{pid_file} /tmp/_pid_file") do
  its(:exit_status) { should eq 1 }
end
