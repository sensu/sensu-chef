require_relative "../spec_helper"
require 'json'

describe "sensu_base_config" do

  let(:single_broker_config) do
    {
      "host" => "10.0.0.6",
      "port" => 5671,
      "vhost" => "/sensu",
      "user" => "sensu",
      "password" => "secret",
      "heartbeat" => 30,
      "prefetch" => 50,
      "ssl" => {
        "cert_chain_file" => "/etc/sensu/ssl/cert.pem",
        "private_key_file" => "/etc/sensu/ssl/key.pem"
      },
      "single_broker" => true
    }
  end

  let(:multiple_broker_config) do
    {
      "hosts" => [ "10.0.0.6", "10.0.0.7", "10.0.0.8" ],
      "host" => "192.168.1.1",
      "port" => 5671,
      "vhost" => "/sensu",
      "user" => "sensu",
      "password" => "secret",
      "heartbeat" => 30,
      "prefetch" => 50,
      "ssl" => {
        "cert_chain_file" => "/etc/sensu/ssl/cert.pem",
        "private_key_file" => "/etc/sensu/ssl/key.pem"
      }
    }
  end

  let(:multiple_broker_json) do
    [
      {
        "host" => "10.0.0.6",
        "port" => 5671,
        "vhost" => "/sensu",
        "user" => "sensu",
        "password" => "secret",
        "heartbeat" => 30,
        "prefetch" => 50,
        "ssl" => {
          "cert_chain_file" => "/etc/sensu/ssl/cert.pem",
          "private_key_file" => "/etc/sensu/ssl/key.pem"
        }
      },
      {
        "host" => "10.0.0.7",
        "port" => 5671,
        "vhost" => "/sensu",
        "user" => "sensu",
        "password" => "secret",
        "heartbeat" => 30,
        "prefetch" => 50,
        "ssl" => {
          "cert_chain_file" => "/etc/sensu/ssl/cert.pem",
          "private_key_file" => "/etc/sensu/ssl/key.pem"
        }
      },
      {
        "host" => "10.0.0.8",
        "port" => 5671,
        "vhost" => "/sensu",
        "user" => "sensu",
        "password" => "secret",
        "heartbeat" => 30,
        "prefetch" => 50,
        "ssl" => {
          "cert_chain_file" => "/etc/sensu/ssl/cert.pem",
          "private_key_file" => "/etc/sensu/ssl/key.pem"
        }
      }
    ]
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      :platform => "ubuntu",
      :version => "14.04",
      :step_into => ['sensu_base_config', 'sensu_json_file']
    ) do |node|
      node.override["sensu"]["transport"]["chefspec"] = true
      node.override["sensu"]["redis"]["chefspec"] = true
      node.override["sensu"]["api"]["chefspec"] = true
      node.override["sensu"]["rabbitmq"] = single_broker_config
    end.converge("sensu::default")
  end

  let(:base_config_json) { chef_run.file("/etc/sensu/config.json") }

  it "creates a base sensu configuration at /etc/sensu/config.json" do
    expect(chef_run).to create_sensu_json_file("/etc/sensu/config.json")
  end

  context "base configuration is derived from node attributes" do
    %w[ transport redis api ].each do |kw|
      it "#{kw} node attributes are present in base configuration" do
        content = JSON.parse(base_config_json.content)
        expect(content[kw]["chefspec"]).to eq(true)
      end
    end
  end

  context "single rabbitmq host provided" do
    it "yields a rabbitmq array with a single hash" do
      content = JSON.parse(base_config_json.content)
      expect(content["rabbitmq"].is_a?(Array)).to eq(true)
      expect(content["rabbitmq"][0].is_a?(Hash)).to eq(true)
      expect(content["rabbitmq"][0]).to eq(single_broker_config)
    end
  end

  context "multiple rabbitmq hosts provided" do

    before do
      chef_run.node.override["sensu"]["rabbitmq"] = multiple_broker_config
      chef_run.converge("sensu::default")
    end

    it "yields a rabbitmq array containing multiple brokers" do
      content = JSON.parse(base_config_json.content)
      expect(content["rabbitmq"].is_a?(Array)).to eq(true)
      expect(content["rabbitmq"]).to eq(multiple_broker_json)
    end
  end

end
