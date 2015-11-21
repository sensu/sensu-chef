require 'rspec'
require 'fauxhai'
require_relative '../../../libraries/sensu_helpers.rb'

describe Sensu::Helpers do

  let(:node) { Fauxhai.mock(:platform => 'ubuntu', :version => '14.04').data }

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
end
