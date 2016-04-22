require 'spec_helper'

%w[
  check-http.rb
  check-haproxy.rb
  check-banner.rb
  check-socket.rb
  check-dns.rb
].each do |plugin|
  describe file(File.join(sensu_directory, "plugins", plugin)) do
    it { should be_file }
    it { should be_mode 755 } unless windows?
    it { should be_owned_by "root" }
    it { should be_grouped_into "sensu" } unless windows?
  end
end

describe file(File.join(sensu_directory, "handlers", "handler-pagerduty.rb")) do
  it { should be_file }
  it { should be_mode 755 } unless windows?
  it { should be_owned_by "root" }
  it { should be_grouped_into "sensu" } unless windows?
end

profiler_extension = windows? ? 'wmi_metrics.rb' : 'system_profile.rb'

describe file(File.join(sensu_directory , "extensions", profiler_extension)) do
  it { should be_file }
  it { should be_mode 755 } unless windows?
  it { should be_owned_by "root" }
  it { should be_grouped_into "sensu" } unless windows?
end
