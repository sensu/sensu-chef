require_relative 'spec_helper'

describe 'sensu-test::good_checks' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(:platform => 'ubuntu', :version => '14.04').converge(
      described_recipe
    )
  }

  it "creates valid_standalone_check sensu_check" do
    expect(chef_run).to create_sensu_check("valid_standalone_check").with(:standalone => true)
  end

  it "creates valid_pubsub_check sensu_check" do
    expect(chef_run).to create_sensu_check("valid_pubsub_check").with(:subscribers => ['all'])
  end

end

describe 'sensu-test::bad_check_name' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(:platform => 'ubuntu', :version => '14.04').converge(
      described_recipe
    )
  }

  it "raises an exception when the check name contains invalid characters" do
    expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
  end
end

describe 'sensu-test::bad_check_attributes' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(:platform => 'ubuntu', :version => '14.04').converge(
      described_recipe
    )
  }

  it "raises an exception when the check has neither subscribers nor standalone attributes" do
    expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
  end
end
