require 'spec_helper'
require 'serverspec'
require 'json'
set :backend, :exec

unless windows?
  describe file('/etc/sensu/conf.d/checks/valid_proxy_client_check.json') do
    it { should be_file }
    its(:content_as_json) do
      should include('checks' =>
             include('valid_proxy_client_check' =>
             include(
               'command' => 'true',
               'standalone' => true,
               'source' => 'some-site-being-monitored',
               'interval' => 20
             )))
    end
  end
end
