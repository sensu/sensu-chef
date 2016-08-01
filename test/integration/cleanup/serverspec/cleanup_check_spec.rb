require 'spec_helper'

describe file('/etc/sensu/conf.d/checks/check_to_be_removed.json') do
  it { should_not exist }
end

# ensure that we did not remove any checks that still have chef resources for
describe file('/etc/sensu/conf.d/checks/test.json') do
  it { should exist }
end
