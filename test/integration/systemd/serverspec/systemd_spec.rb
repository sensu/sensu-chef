require 'spec_helper'
require 'service_dependency_helper'

describe file('/etc/init.d/sensu-server') do
  it { should_not exist }
end

describe service("sensu-server") do
  it { should be_enabled }
  it { should be_running }
end

describe command('systemctl status sensu-server') do
  its(:stdout) { should match %r{Loaded: loaded \(/etc/systemd/system/sensu-server.service;} }
end

describe file('/etc/init.d/sensu-client') do
  it { should_not exist }
end

describe service("sensu-client") do
  it { should be_enabled }
  it { should be_running }
end

describe command('systemctl status sensu-client') do
  its(:stdout) { should match %r{Loaded: loaded \(/etc/systemd/system/sensu-client.service;} }
end

describe file('/etc/init.d/sensu-api') do
  it { should_not exist }
end

describe service("sensu-api") do
  it { should be_enabled }
  it { should be_running }
end

describe command('systemctl status sensu-api') do
  its(:stdout) { should match %r{Loaded: loaded \(/etc/systemd/system/sensu-api.service;} }
end
