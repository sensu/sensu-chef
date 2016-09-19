require_relative "spec_helper"
require_relative "common_examples"

describe "sensu::default" do
  include_context("sensu data bags")

  context "when running on unix-like platforms" do
    let(:sensu_pkg_name) { 'sensu' }
    let(:sensu_directory) { '/etc/sensu' }
    let(:log_directory) { '/var/log/sensu' }

    context "when running on ubuntu linux" do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(:platform => "ubuntu", :version => "12.04") do |node, server|
          server.create_data_bag("sensu", ssl_data_bag_item)
        end.converge(described_recipe)
      end

      it "includes the sensu::_linux recipe" do
        expect(chef_run).to include_recipe("sensu::_linux")
      end

      it "installs the sensu package" do
        expect(chef_run).to install_package('sensu')
      end

      it_behaves_like('sensu default recipe')
    end

    context "when running on aix" do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(:platform => "aix", :version => "7.1") do |node, server|
          server.create_data_bag("sensu", ssl_data_bag_item)
        end.converge(described_recipe)
      end

      it "includes the sensu::_aix recipe" do
        expect(chef_run).to include_recipe("sensu::_aix")
      end

      it "installs the sensu package" do
        expect(chef_run).to install_package('sensu')
      end

      it_behaves_like('sensu default recipe')
    end
  end

  context "when running on windows platform" do
    let(:sensu_pkg_name) { 'Sensu' }
    let(:sensu_directory) { 'C:\etc\sensu' }
    let(:log_directory) { 'C:\var\log\sensu' }
    let(:dotnet_recipe) { "ms_dotnet::ms_dotnet3" }

    let(:chef_run) do
      ChefSpec::ServerRunner.new(
        :platform => "windows",
        :version => "2008R2"
      ) do |node, server|
        server.create_data_bag("sensu", ssl_data_bag_item)
        node.override["lsb"] = {}
        node.override["sensu"]["windows"]["dotnet_major_version"] = 3
      end.converge(described_recipe)
    end

    it "includes the sensu::_windows recipe" do
      expect(chef_run).to include_recipe("sensu::_windows")
    end

    context "when install_dotnet is true" do
      it "includes the appropriate recipe from the ms_dotnet cookbook" do
        expect(chef_run).to include_recipe(dotnet_recipe)
      end
    end

    context "when install_dotnet is false" do
      it "does not include a recipe from the ms_dotnet cookbook" do
        chef_run.node.override["sensu"]["windows"]["install_dotnet"] = false
        chef_run.converge(described_recipe)
        expect(chef_run).to_not include_recipe(dotnet_recipe)
      end
    end

    it_behaves_like('sensu default recipe')
  end

end
