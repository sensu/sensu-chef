require 'spec_helper'
require 'service_dependency_helper'

describe service("sensu-server") do
  it { should be_enabled }
  it { should be_running }
end

describe service("sensu-client") do
  it { should be_enabled }
  it { should be_running }
end

describe service("sensu-api") do
  it { should be_enabled }
  it { should be_running }
end

describe file("/etc/sensu/config.json") do
  it { should contain '"user": "sensu_server"' }
  it { should contain '"permissions": ".* .* .*"' }
end

describe command("rabbitmqctl list_permissions -p /sensu") do
  its(:stdout) { should match /sensu_client\s+\^foo-\.\*\s+\.\*\s+\.\*/ }
  its(:stdout) { should match /sensu_server\s+\.\*\s+\.\*\s+\.\*/ }
end
