require 'spec_helper'
require 'service_dependency_helper'

describe file('/etc/init.d/sensu-server') do
  it { should_not exist }
end

describe service("sensu-server") do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/init.d/sensu-client') do
  it { should_not exist }
end

describe service("sensu-client") do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/init.d/sensu-api') do
  it { should_not exist }
end

describe service("sensu-api") do
  it { should be_enabled }
  it { should be_running }
end
