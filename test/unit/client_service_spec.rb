require_relative "spec_helper"

describe "sensu::client_service" do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(:platform => "ubuntu", :version => "14.04").converge(described_recipe)
  end

  it "enables the sensu-client service in ubuntu 14.04" do
    expect(chef_run).to enable_sensu_service("sensu-client")
  end

  it "starts the sensu-client service in ubuntu 14.04" do
    expect(chef_run).to start_sensu_service("sensu-client")
  end
end

describe "sensu::client_service" do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(:platform => "ubuntu", :version => "16.04").converge(described_recipe)
  end

  it "enables the sensu-client service in ubuntu 16.04" do
    expect(chef_run).to enable_sensu_service("sensu-client")
  end

  it "starts the sensu-client service in ubuntu 16.04" do
    expect(chef_run).to start_sensu_service("sensu-client")
  end
end
