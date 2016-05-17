require_relative "spec_helper"

describe "sensu::client_service" do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(:platform => "ubuntu", :version => "12.04") do |node, server|
      # allow(node).to receive(:chef_environment).and_return(env.name)
      # server.create_environment(env.name, { description: "an environment for unit tests" })
      # server.create_data_bag("sensu", sensu_data_bag)
      # server.create_node(rabbitmq_node_name, rabbitmq_node_attrs)
    end.converge(described_recipe)
  end

  it "enables the sensu-client service in ubuntu 12.04" do
    expect(chef_run).to enable_sensu_service("sensu-client")
  end

  it "starts the sensu-client service in ubuntu 12.04" do
    expect(chef_run).to start_sensu_service("sensu-client")
  end
end

describe "sensu::client_service" do
  cached(:chef_run) do
    ChefSpec::ServerRunner.new(:platform => "ubuntu", :version => "14.04") do |node, server|
      # allow(node).to receive(:chef_environment).and_return(env.name)
      # server.create_environment(env.name, { description: "an environment for unit tests" })
      # server.create_data_bag("sensu", sensu_data_bag)
      # server.create_node(rabbitmq_node_name, rabbitmq_node_attrs)
    end.converge(described_recipe)
  end

  it "enables the sensu-client service in ubuntu 14.04" do
    expect(chef_run).to enable_sensu_service("sensu-client")
  end

  it "starts the sensu-client service in ubuntu 14.04" do
    expect(chef_run).to start_sensu_service("sensu-client")
  end
end
