require 'spec_helper'

describe file("/etc/sensu/config.json") do
  its(:content) { should match /"name": "test"/ }
  its(:content) { should_not match /"id": / }
  it { should be_grouped_into('nogroup') }
end
