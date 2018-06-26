require_relative 'spec_helper'

describe 'sensu-test::good_checks' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(:platform => 'ubuntu', :version => '16.04').converge(
      described_recipe
    )
  }

  it "creates valid_check_with_default_interval" do
    expect(chef_run).to create_sensu_check("valid_check_with_default_interval").with(:interval => 60).with(:cron => nil)
  end

  it "creates valid_cron_check" do
    expect(chef_run).to create_sensu_check("valid_cron_check").with(
      :cron => "* * * * *",
      :interval => nil)
  end

  
  it "creates valid_standalone_check sensu_check" do
    expect(chef_run).to create_sensu_check("valid_standalone_check").with(:standalone => true)
  end

  it "creates valid_pubsub_check sensu_check" do
    expect(chef_run).to create_sensu_check("valid_pubsub_check").with(:subscribers => ['all'])
  end

  it "deletes removed_check without specifying subscriptions/standalone" do
    expect(chef_run).to delete_sensu_check("removed_check").with(
      :subscribers => nil,
      :standalone => nil
    )
  end

end

describe 'sensu-test::bad_check_name' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(:platform => 'ubuntu', :version => '16.04').converge(
      described_recipe
    )
  }

  it "raises an exception when the check name contains invalid characters" do
    expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
  end
end

describe 'sensu-test::bad_check_attributes' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(:platform => 'ubuntu', :version => '16.04').converge(
      described_recipe
    )
  }

  it "raises an exception when the check has neither subscribers nor standalone attributes" do
    expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
  end
end


describe 'sensu-test::bad_cron_and_interval' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(:platform => 'ubuntu', :version => '16.04').converge(
      described_recipe
    )
  }

  it "raises an exception when the check has both cron and interval attributes" do
    expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
  end
end

describe 'sensu-test::bad_check_no_interval_or_cron' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(:platform => 'ubuntu', :version => '16.04').converge(
      described_recipe
    )
  }

  it "raises an exception when in check both cron and interval are false" do
    expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
  end
end

describe 'sensu-test::bad_check_invalid_interval' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(:platform => 'ubuntu', :version => '16.04').converge(
      described_recipe
    )
  }

  it "raises an exception when in check interval is equal or less than 0" do
    expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
  end
end