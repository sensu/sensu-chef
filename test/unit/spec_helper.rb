require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start!

RSpec.shared_context('sensu data bags') do
  let(:ssl_data_bag_item) do
    # JSON.parse(
    #   File.read(File.join(File.dirname(__FILE__), '../integration/data_bags/sensu/ssl.json'))
    # )
    {
      'ssl' => {
        'client' => {
          'cert' => '',
          'key' => ''
        },
        'server' => {
          'cert' => '',
          'key' => '',
          'cacert' => ''
        }
      },
      'config' => {
      },
      'enterprise' => {
      }
    }
  end
end
