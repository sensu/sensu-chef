require "serverspec"
require "net/http"
require "uri"

set :backend, :exec
set :path, "/bin:/usr/bin:/sbin:/usr/sbin"

describe file("/opt/sensu/sv/sensu-server/supervise/pid") do
  its(:content) { should match /^[0-9]+$/ }
end

describe file("/opt/sensu/sv/sensu-client/supervise/pid") do
  its(:content) { should match /^[0-9]+$/ }
end

describe file("/opt/sensu/sv/sensu-api/supervise/pid") do
  its(:content) { should match /^[0-9]+$/ }
end
