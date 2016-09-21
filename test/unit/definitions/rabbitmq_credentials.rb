require_relative "../spec_helper"

describe "sensu-test::rabbitmq_credentials" do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      :platform => "ubuntu",
      :version => "12.04"
    ).converge(described_recipe)
  end

  let(:rmq_state_set) do
    chef_run.node.run_state['sensu']['rabbitmq_credentials']['test']['testuser']
  end

  it "creates the rabbitmq vhost" do
    expect(chef_run).to add_rabbitmq_vhost("test")
  end

  it "creates the rabbitmq user" do
    expect(chef_run).to add_rabbitmq_user("testuser").with(
      :password => "testpassword",
      :vhost => "test",
      :permissions => ".* .* .*",
      :action => [:add, :set_permissions]
    )
  end

  it "sets state in node.run_state to avoid CHEF-3694 warnings" do
    expect(rmq_state_set).to eq(true)
  end
end
