require_relative "../spec_helper"

describe 'sensu_gem' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      :step_into => ['sensu_gem'],
      :file_cache_path => '/tmp',
      :platform => 'ubuntu',
      :version => '14.04'
    ).converge('sensu-test::gem_lwrp')
  end

  it 'defaults to action :install' do
    expect(chef_run).to install_gem_package('sensu-plugins-sensu')
  end

  context 'action :install' do
    it 'installs the specified gem package' do
      expect(chef_run).to install_gem_package('sensu-plugins-slack')
    end

    context 'version specified' do
      it 'installs the specified version of the gem package' do
        expect(chef_run).to install_gem_package('sensu-plugins-chef').with(:version => '0.0.5')
      end
    end

    context 'source specified' do
      it 'installs the specified gem package from the specified source' do
        expect(chef_run).to install_gem_package('sensu-plugins-memory-checks').with(:source => '/tmp/sensu-plugins-memory-checks.gem')
      end
    end
  end

  context 'action :remove' do
    it 'removes the specified gem package' do
      expect(chef_run).to remove_gem_package('sensu-plugins-hipchat')
    end
  end

  context 'action :upgrade' do
    it 'installs or upgrades the specified gem package to the specified version' do
      expect(chef_run).to upgrade_gem_package('sensu-plugins-disk-checks').with(:version => '1.1.2')
    end
  end

end
