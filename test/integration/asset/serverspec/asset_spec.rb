require "serverspec"
require "net/http"
require "uri"

set :backend, :exec
set :path, "/bin:/usr/bin:/sbin:/usr/sbin"

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

describe file("/etc/sensu/handlers/pagerduty.rb") do
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
