require 'spec_helper'
require 'service_dependency_helper'

describe service('sensu-server') do
  it { should be_enabled }
  it { should be_running }
end

describe service('sensu-client') do
  it { should be_enabled }
  it { should be_running }
end

describe service('sensu-api') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/sensu/config.json') do
  its(:content) { should match /encryptedPassword42/ }
  its(:content) { should_not match /"id": / }
end
