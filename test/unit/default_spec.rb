require_relative "spec_helper"
require_relative "common_examples"

describe "sensu::default" do
  include_context("sensu data bags")

  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with("sensu::_windows")
  end

  context "when running on non-windows platform" do

    let(:sensu_directory) { '/etc/sensu' }
    let(:log_directory) { '/var/log/sensu' }

    let(:chef_run) do
      ChefSpec::ServerRunner.new(:platform => "ubuntu", :version => "12.04") do |node, server|
        server.create_data_bag("sensu", ssl_data_bag_item)
      end.converge(described_recipe)
    end

    it "includes the sensu::_linux recipe" do
      expect(chef_run).to include_recipe("sensu::_linux")
    end

    it_behaves_like('sensu default recipe')
  end

  context "when running on windows platform" do

    let(:sensu_directory) { 'C:\etc\sensu' }
    let(:log_directory) { 'C:\var\log\sensu' }

    let(:chef_run) do
      ChefSpec::ServerRunner.new(:platform => "windows", :version => "2003R2") do |node, server|
        server.create_data_bag("sensu", ssl_data_bag_item)
        node.set["lsb"] = {}
      end.converge(described_recipe)
    end

    it "includes the sensu::_windows recipe" do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with("sensu::_windows")
      chef_run
    end

    it_behaves_like('sensu default recipe')
  end

end
