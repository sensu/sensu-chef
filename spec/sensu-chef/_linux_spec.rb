require 'spec_helper'

describe 'sensu::_linux' do
  context 'amazon_linux_2' do
    let(:solo) do
      ChefSpec::SoloRunner.new(:platform => 'amazon',
                               :version => '2')
    end
    let(:chef_run) do
      # We need to insert this into the run_context
      # Because we aren't loading the recipe which includes this resource
      solo.converge(described_recipe) do
        solo.resource_collection.insert(
            Chef::Resource::RubyBlock.new('sensu_service_trigger', solo.run_context)
        )
      end
    end
    it 'runs the _linux recipe' do
      expect(chef_run).to add_yum_repository('sensu').with(baseurl: 'http://repositories.sensuapp.org/yum/7/$basearch/')
      expect(chef_run).to install_yum_package('sensu').with(version: '1.2.0-1.el7')
    end
  end
  context 'amazon_linux_2-pre' do
    let(:solo) do
      ChefSpec::SoloRunner.new(:platform => 'amazon',
                               :version => '2018.03')
    end
    let(:chef_run) do
      # We need to insert this into the run_context
      # Because we aren't loading the recipe which includes this resource
      solo.converge(described_recipe) do
        solo.resource_collection.insert(
            Chef::Resource::RubyBlock.new('sensu_service_trigger', solo.run_context)
        )
      end
    end
    it 'runs the _linux recipe' do
      expect(chef_run).to add_yum_repository('sensu').with(baseurl: 'http://repositories.sensuapp.org/yum/6/$basearch/')
      expect(chef_run).to install_yum_package('sensu').with(version: '1.2.0-1.el6')
    end
  end
  context 'ubuntu_bionic' do
    let(:solo) do
      ChefSpec::SoloRunner.new(:platform => 'ubuntu',
                               :version => '18.04')
    end
    let(:chef_run) do
      # We need to insert this into the run_context
      # Because we aren't loading the recipe which includes this resource
      solo.converge(described_recipe) do
        solo.resource_collection.insert(
            Chef::Resource::RubyBlock.new('sensu_service_trigger', solo.run_context)
        )
      end
    end
    it 'runs the _linux recipe' do
      expect(chef_run).to add_apt_repository('sensu')
      expect(chef_run).to add_apt_preference('sensu')
    end
  end
end
