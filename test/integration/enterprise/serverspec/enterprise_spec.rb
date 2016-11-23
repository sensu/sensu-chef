require 'spec_helper'
require 'service_dependency_helper'

describe file("/var/cache/sensu-enterprise") do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'sensu' }
  it { should be_grouped_into 'sensu' }
end

describe service("sensu-enterprise") do
  it { should be_enabled }
  it { should be_running }
end
