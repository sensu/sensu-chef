require 'spec_helper'

describe file("/etc/sensu/config.json") do
  its(:content) { should match /"name": "test"/ }
  its(:content) { should_not match /"id": / }
end
