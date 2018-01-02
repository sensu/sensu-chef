require 'serverspec'

set :backend, :exec

describe package('sensu-backend') do
  it { should be_installed }
end
