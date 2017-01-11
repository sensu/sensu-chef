require_relative "../spec_helper"

describe 'sensu_filter' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      :step_into => ['sensu_filter'],
      :file_cache_path => '/tmp',
      :platform => 'ubuntu',
      :version => '14.04'
    ).converge('sensu-test::filter_lwrp')
  end

  it 'defaults to action :create' do
    %w(always never daytime nighttime).each do |f|
      expect(chef_run).to create_sensu_filter(f)
    end
  end

  context 'action :create' do
    it 'creates the specified filter definition' do
      f = '/etc/sensu/conf.d/filters/always.json'
      expected = {
        'filters' => {
          'always' => { :attributes => { :check => { :timestamp => 'eval: true' } } }
        }
      }
      expect(chef_run).to create_sensu_json_file(f).with(:content => expected)
    end

    context 'negate specified' do
      it 'creates the specified filter definition' do
        f = '/etc/sensu/conf.d/filters/never.json'
        expected = {
          'filters' => {
            'never' => {
              :attributes => { :check => { :timestamp => 'eval: true' } },
              :negate => true
            }
          }
        }
        expect(chef_run).to create_sensu_json_file(f).with(:content => expected)
      end
    end

    context 'days specified' do
      context 'with symbol hash keys' do
        it 'creates the specified filter definition' do
          f = '/etc/sensu/conf.d/filters/daytime.json'
          expected = {
            'filters' => {
              'daytime' => {
                :attributes => { :check => { :timestamp => 'eval: true' } },
                :when => { :days => { :all => [{ :begin => '09:00 AM', :end => '05:00 PM' }] } }
              }
            }
          }
          expect(chef_run).to create_sensu_json_file(f).with(:content => expected)
        end
      end

      context 'with string hash keys' do
        it 'creates the specified filter definition' do
          f = '/etc/sensu/conf.d/filters/nighttime.json'
          expected = {
            'filters' => {
              'nighttime' => {
                :attributes => { 'check' => { 'timestamp' => 'eval: true' } },
                :when => { :days => { 'all' => [{ 'begin' => '05:00 PM', 'end' => '09:00 AM' }] } }
              }
            }
          }
          expect(chef_run).to create_sensu_json_file(f).with(:content => expected)
        end
      end
    end
  end

  context 'action :delete' do
    it 'deletes the specified filter' do
      expect(chef_run).to delete_sensu_filter('delete_me')
    end

    it 'deletes the specified filter definition' do
      f = '/etc/sensu/conf.d/filters/delete_me.json'
      expect(chef_run).to delete_sensu_json_file(f)
    end
  end
end
