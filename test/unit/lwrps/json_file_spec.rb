require_relative "../spec_helper"

describe 'sensu_json_file' do
  let(:test_content) { { :lol => "wtfbbq" } }
  let(:test_directory_mode) { "0755" }
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      :step_into => ['sensu_json_file'],
      :file_cache_path => '/tmp',
      :platform => "ubuntu",
      :version => "14.04"
    ) do |node|
      node.override['sensu']['directory_mode'] = test_directory_mode
    end.converge('sensu-test::json_file')
  end

  it 'creates the /etc/sensu directory using value of directory_mode attribute' do
    expect(chef_run).to create_directory('/etc/sensu').with({ :mode => test_directory_mode })
  end

  it 'creates a "pretty" json file with the provided content' do
    expect(chef_run).to render_file('/etc/sensu/foo.json').with_content(
      JSON.pretty_generate(test_content)
    )
  end

end
