require_relative "spec_helper"

describe "sensu::_enterprise_repo" do
  let(:data_bag_item) do
    {
      "enterprise" => {
        "repository" => {
          "credentials" => {
            "user" => "chefspec",
            "password" => "moartests!"
          }
        }
      }
    }
  end

  %w(stable unstable).each do |repo_designation|
    context "apt platforms" do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(:platform => "ubuntu", :version => "12.04") do |node, server|
          node.override["sensu"]["enterprise"]["use_unstable_repo"] = true unless repo_designation == "stable"
          server.create_data_bag("sensu", data_bag_item)
        end.converge(described_recipe)
      end

      context "using upstream #{repo_designation} repo" do
        it "creates sensu-enterprise apt #{repo_designation} repository definition" do
          expect(chef_run).to add_apt_repository("sensu-enterprise").with(
            :uri => "http://chefspec:moartests!@enterprise.sensuapp.com/apt",
            :key => "http://chefspec:moartests!@enterprise.sensuapp.com/apt/pubkey.gpg",
            :distribution => "sensu-enterprise",
            :components => repo_designation == "unstable" ?  ["unstable"] : ["main"]
          )
        end
      end

      context "using custom host with #{repo_designation} repo" do
        before do
          chef_run.node.override["sensu"]["enterprise"]["repo_host"] = "chefspec.example.com"
          chef_run.converge(described_recipe)
        end

        it "creates sensu-enterprise yum #{repo_designation} repository definition using custom repo host" do
          expect(chef_run).to add_apt_repository("sensu-enterprise").with(
            :uri => "http://chefspec:moartests!@chefspec.example.com/apt",
            :key => "http://chefspec:moartests!@chefspec.example.com/apt/pubkey.gpg",
            :distribution => "sensu-enterprise",
            :components => repo_designation == "unstable" ?  ["unstable"] : ["main"]
          )
        end
      end
    end

    context "yum platforms" do

      let(:chef_run) do
        ChefSpec::ServerRunner.new(:platform => "centos", :version => "6.6") do |node, server|
          node.override["sensu"]["enterprise"]["use_unstable_repo"] = true unless repo_designation == "stable"
          server.create_data_bag("sensu", data_bag_item)
        end.converge(described_recipe)
      end

      let(:yum_repo_designation) { repo_designation == "unstable" ? "yum-unstable" : "yum" }

      context "using upstream #{repo_designation} repo" do
        it "creates sensu-enterprise yum #{repo_designation} repository definition" do
          expect(chef_run).to add_yum_repository("sensu-enterprise").with(
            :url => "http://chefspec:moartests!@enterprise.sensuapp.com/#{yum_repo_designation}/noarch/",
            :gpgcheck => false
          )
        end

        it "creates sensu-enterprise-dashboard yum #{repo_designation} repository definition" do
          expect(chef_run).to add_yum_repository("sensu-enterprise-dashboard").with(
            :url => "http://chefspec:moartests!@enterprise.sensuapp.com/#{yum_repo_designation}/$basearch/",
            :gpgcheck => false
          )
        end
      end

      context "using custom host with #{repo_designation} repo" do
        before do
          chef_run.node.override["sensu"]["enterprise"]["repo_host"] = "chefspec.example.com"
          chef_run.converge(described_recipe)
        end

        it "creates sensu-enterprise yum #{repo_designation} repository definition using custom repo host" do
          expect(chef_run).to add_yum_repository("sensu-enterprise").with(
            :url => "http://chefspec:moartests!@chefspec.example.com/#{yum_repo_designation}/noarch/",
            :gpgcheck => false
          )
        end
      end
    end

  end
end
