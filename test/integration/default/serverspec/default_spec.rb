require 'spec_helper'

sensu_pkg_name = windows? ? 'Sensu' : 'sensu'

describe package(sensu_pkg_name) do
  it { should be_installed }
end

describe file(File.join(sensu_directory, "config.json")) do
  its(:content) { should match /"name": "test"/ }
  its(:content) { should_not match /"id": / }
  # it { should be_grouped_into('nogroup') } unless windows?
end
