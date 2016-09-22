require 'rspec'
require 'fauxhai'
require_relative '../../../libraries/sensu_helpers.rb'

describe Sensu::Helpers do

  let(:node) { Fauxhai.mock(:platform => 'ubuntu', :version => '14.04').data }
  let(:unix_omnibus_gem_path) { '/opt/sensu/embedded/bin/gem' }
  let(:windows_omnibus_gem_path) { 'c:\opt\sensu\embedded\bin\gem.bat' }

  describe ".select_attributes" do
    context 'when the requested attribute exists' do
      it 'returns the requested key/value pair' do
        results = Sensu::Helpers.select_attributes(node, 'platform')
        expect(results.keys).to eq(['platform'])
        expect(results.values).to eq(['ubuntu'])
      end
    end

    context 'when the requested attribute does not exist' do
      it 'returns an empty hash' do
        expect(Sensu::Helpers.select_attributes(node, 'hotdog')).to be_empty
      end
    end

    context 'when multiple attributes are requested and all exist' do
      it 'returns a hash containing the requested key/value pairs' do
        results = Sensu::Helpers.select_attributes(node, ['fqdn', 'ipaddress'])
        expect(results.keys).to eq(['fqdn', 'ipaddress'])
        expect(results.values).to eq(['fauxhai.local', '10.0.0.2'])
      end
    end

    context 'when multiple attributes are requested and only a subset exist' do
      it 'returns a hash containing the existing key/value pairs' do
        results = Sensu::Helpers.select_attributes(node, ['platform_version', 'platform_lasagna'])
        expect(results.keys).to eq(['platform_version'])
        expect(results.values).to eq(['14.04'])
      end
    end
  end

  describe ".gem_binary" do
    context 'on unix-like platforms' do
      context 'with omnibus ruby available' do
        before do
          allow(File).to receive(:exists?).with(unix_omnibus_gem_path).and_return(true)
          allow(File).to receive(:exists?).with(windows_omnibus_gem_path).and_return(false)
        end

        it 'returns the full path to the omnibus ruby gem binary' do
          gem_binary = Sensu::Helpers.gem_binary
          expect(gem_binary).to eq(unix_omnibus_gem_path)
        end
      end

      context 'without omnibus ruby available' do

        before do
          allow(File).to receive(:exists?).with(unix_omnibus_gem_path).and_return(false)
          allow(File).to receive(:exists?).with(windows_omnibus_gem_path).and_return(false)
        end

        it 'returns an unqualified path to the gem binary' do
          gem_binary = Sensu::Helpers.gem_binary
          expect(gem_binary).to eq('gem')
        end
      end
    end

    context 'on windows platforms' do
      let(:node) { Fauxhai.mock(:platform => 'windows', :version => '2012R2').data }

      context 'with omnibus ruby available' do
        before do
          allow(File).to receive(:exists?).with(unix_omnibus_gem_path).and_return(false)
          allow(File).to receive(:exists?).with(windows_omnibus_gem_path).and_return(true)
        end

        it 'returns the full path to the omnibus ruby gem binary' do
          gem_binary = Sensu::Helpers.gem_binary
          expect(gem_binary).to eq(windows_omnibus_gem_path)
        end
      end

      context 'without omnibus ruby available' do

        before do
          allow(File).to receive(:exists?).with(unix_omnibus_gem_path).and_return(false)
          allow(File).to receive(:exists?).with(windows_omnibus_gem_path).and_return(false)
        end

        it 'returns an unqualified path to the gem binary' do
          gem_binary = Sensu::Helpers.gem_binary
          expect(gem_binary).to eq('gem')
        end
      end
    end
  end
end
