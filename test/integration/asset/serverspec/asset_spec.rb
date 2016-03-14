require 'spec_helper'

%w[
  check-http.rb
  check-haproxy.rb
  check-banner.rb
  check-socket.rb
  check-dns.rb
].each do |plugin|
  describe file(File.join("/etc/sensu/plugins", plugin)) do
    it { should be_file }
    it { should be_mode 755 }
    it { should be_owned_by "root" }
    it { should be_grouped_into "sensu" }
  end
end

describe file("/etc/sensu/handlers/handler-pagerduty.rb") do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "sensu" }
end

describe file("/etc/sensu/extensions/system_profile.rb") do
  it { should be_file }
  it { should be_mode 755 }
  it { should be_owned_by "root" }
  it { should be_grouped_into "sensu" }
end
