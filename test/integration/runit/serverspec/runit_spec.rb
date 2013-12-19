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

describe file("/opt/sensu/sv/sensu-server/supervise/pid") do
  its(:content) { should match /^[0-9]+$/ }
end

describe file("/opt/sensu/sv/sensu-client/supervise/pid") do
  its(:content) { should match /^[0-9]+$/ }
end

describe file("/opt/sensu/sv/sensu-api/supervise/pid") do
  its(:content) { should match /^[0-9]+$/ }
end

describe file("/opt/sensu/sv/sensu-dashboard/supervise/pid") do
  its(:content) { should match /^[0-9]+$/ }
end
