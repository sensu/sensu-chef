require 'chefspec'
require_relative '../../../libraries/sensu_json_file.rb'

describe 'Sensu::JSONFile' do

  let(:config) do
    {
      "client" => { "name" => "test", "address" => "localhost", "subscriptions" => [ "test" ] },
      "rabbitmq" => { "host" => "172.16.100.100", "port" => 5671, "vhost" => "/sensu", "user" => "sensu", "password" => "sensu" }
    }
  end

  let(:stubbed_file_content) { config.to_json }
  let(:stubbed_file_path) { '/tmp/foo.json' }

  before(:each) do
    allow(File).to receive(:read).with(stubbed_file_path).and_return(stubbed_file_content)
  end

  describe ".load_json" do
   
    it 'returns a non-empty hash' do
      result = Sensu::JSONFile.load_json(stubbed_file_path)
      expect(result).to be_a(Hash)
      expect(result.empty?).to eq(false)
    end

    it 'returns a hash containing the expected keys' do
      result = Sensu::JSONFile.load_json(stubbed_file_path)
      expect(result.keys).to eq(['client', 'rabbitmq'])
    end
  end

  describe ".dump_json" do
    it 'returns a non-empty string, terminated with a new line' do
      result = Sensu::JSONFile.dump_json(config)
      expect(result).to be_a(String)
      expect(result).to match(/^.*\n$/)
    end
  end

  describe ".to_mash" do
    it 'converts a hash into a mash' do
      result = Sensu::JSONFile.to_mash(config)
      expect(result).to be_a(Mash)
      expect(result.keys).to eq(config.keys)
      expect(result.values).to eq(config.values)
    end
  end

  describe ".compare_content" do
    it 'returns false when comparing the content of a file to a non-matching hash' do
      result = Sensu::JSONFile.compare_content(stubbed_file_path, {})
      expect(result).to eq(false)
    end

    it 'returns true when comparing the content of a file to a matching hash' do
      result = Sensu::JSONFile.compare_content(stubbed_file_path, config)
      expect(result).to eq(true)
    end
  end

end
