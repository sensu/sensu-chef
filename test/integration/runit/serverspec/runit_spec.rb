require 'spec_helper'
require 'service_dependency_helper'

describe file("/opt/sensu/sv/sensu-server/supervise/pid") do
  its(:content) { should match /^[0-9]+$/ }
end

describe file("/opt/sensu/sv/sensu-client/supervise/pid") do
  its(:content) { should match /^[0-9]+$/ }
end

describe file("/opt/sensu/sv/sensu-api/supervise/pid") do
  its(:content) { should match /^[0-9]+$/ }
end
