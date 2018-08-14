require 'spec_helper'

describe 'sensu::_linux' do
  # Test all the versions available in fauxhai
  # https://github.com/chefspec/fauxhai/tree/master/lib/fauxhai/platforms/amazon
  context 'amazon_linux_2' do
    let(:solo) do
      ChefSpec::SoloRunner.new(platform: 'amazon',
                               version: '2')
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

    # TODO: once we no longer support chef versions < 14 we should remove the below test(s)
    ['4.14.55-68.37.amzn2.x86_64',
     'version.amzn2.platform'].each do |older_ohai_platform_version|
      it 'works with older ohai' do
        actual = Sensu::Helpers.amazon_linux_2_rhel_version(older_ohai_platform_version)

        # Assert
        expect(actual).to eq('7')
      end
    end
  end

  ['2018.03',
   '2017.09',
   '2017.03',
   '2016.09',
   '2016.03',
   '2015.09',
   '2015.03'].each do |platform_version|
    context 'amazon_linux_2-pre' do
      let(:solo) do
        ChefSpec::SoloRunner.new(platform: 'amazon',
                                 version: platform_version)
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

  end
  context 'ubuntu_bionic' do
    let(:solo) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu',
                               version: '18.04')
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
