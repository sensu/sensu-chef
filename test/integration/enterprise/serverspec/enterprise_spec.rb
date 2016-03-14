require 'spec_helper'
require 'service_dependency_helper'

describe service("sensu-enterprise") do
  it { should be_enabled }
  it { should be_running }
end
