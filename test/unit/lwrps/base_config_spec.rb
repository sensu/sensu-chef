require_relative "../spec_helper"
require 'json'

describe "sensu_base_config" do

  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      :platform => "ubuntu",
      :version => "14.04",
      :step_into => ['sensu_base_config', 'sensu_json_file']
    ) do |node|
      node.set["sensu"]["transport"]["chefspec"] = true
      node.set["sensu"]["rabbitmq"]["chefspec"] = true
      node.set["sensu"]["redis"]["chefspec"] = true
      node.set["sensu"]["api"]["chefspec"] = true
    end.converge("sensu::default")
  end

  let(:base_config_json) { chef_run.file("/etc/sensu/config.json") }

  it "creates a base sensu configuration at /etc/sensu/config.json" do
    expect(chef_run).to create_sensu_json_file("/etc/sensu/config.json")
  end

  context "base configuration is derived from node attributes" do
    %w( transport rabbitmq redis api ).each do |kw|
      it "#{kw} node attributes are present in base configuration" do
        content = JSON.parse(base_config_json.content)
        expect(content[kw]["chefspec"]).to eq(true)
      end
    end
  end

end
