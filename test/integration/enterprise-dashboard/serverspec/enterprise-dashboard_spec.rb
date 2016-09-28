require 'spec_helper'

describe service("sensu-enterprise-dashboard") do
  it { should be_enabled }
  it { should be_running }
end
