require_relative '../spec_helper'

describe 'sensu_client with minimum required attributes' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      :step_into => %w[sensu_client sensu_json_file],
      :platform => "ubuntu",
      :version => "14.04"
    ).converge('sensu-test::client_lwrp_defaults')
  end

  let(:minimal_client_json) { chef_run.file('/etc/sensu/conf.d/client.json') }
  let(:minimal_client_content) { JSON.parse(minimal_client_json.content)['client'] }

  it 'renders client.json to directory defined by attributes' do
    expect(chef_run).to create_sensu_json_file(minimal_client_json.name)
  end

  it 'configures client name' do
    expect(minimal_client_content['name']).to eq('default_client')
  end

  it 'configures client address' do
    expect(minimal_client_content['address']).to eq('10.0.0.2')
  end

  it 'configures client subscriptions' do
    expect(minimal_client_content['subscriptions']).to eq(['none'])
  end

  it 'does not provide configuration for unconfigured optional attributes' do
    %w[ deregister deregistration keepalive keepalives redact registration safe_mode socket ].each do
      |attr|
      expect(minimal_client_content.key?(attr)).to eq(false)
    end
  end
end

describe 'sensu_client with optional attributes' do
  let(:sensu_dir) { "/opt/sensu/etc" }

  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      :step_into => %w[sensu_client sensu_json_file],
      :platform => "ubuntu",
      :version => "14.04"
    ) do |node|
      node.override["sensu"]["directory"] = sensu_dir
    end.converge('sensu-test::client_lwrp')
  end

  let(:client_json) { chef_run.file(::File.join(sensu_dir, 'conf.d', 'client.json')) }

  let(:client_content) { JSON.parse(client_json.content)['client'] }

  it 'renders client.json to directory defined by attributes' do
    expect(chef_run).to create_sensu_json_file(client_json.name)
  end

  it 'configures client name' do
    expect(client_content['name']).to eq('lwrp_client')
  end

  it 'configures client address' do
    expect(client_content['address']).to eq('10.0.0.1')
  end

  it 'configures client subscriptions' do
    expect(client_content['subscriptions']).to eq(['all'])
  end

  it 'configures client keepalives' do
    expect(client_content['keepalives']).to eq(false)
  end

  it 'configures client keepalive behavior' do
    expect(client_content['keepalive']).to eq(
      'handler' => 'pagerduty',
      'thresholds' => {
        'warning' => 40,
        'critical' => 60
      }
    )
  end

  it 'configures client safe_mode' do
    expect(client_content['safe_mode']).to eq(true)
  end

  it 'configures client socket' do
    expect(client_content['socket']).to eq('bind' => '0.0.0.0', 'port' => 4040)
  end

  it 'configures attributes for client redaction' do
    expect(client_content['redact']).to eq(['obscure_api_token_name'])
  end

  it 'configures client registration' do
    expect(client_content['registration']).to eq('handler' => 'register_client')
  end

  it 'configures client to deregister' do
    expect(client_content['deregister']).to eq(true)
  end

  it 'configures client deregistration' do
    expect(client_content['deregistration']).to eq('handler' => 'deregister_client')
  end

  it 'configures custom client attributes specified as additional' do
    expect(client_content['bacon']).to eq(true)
    expect(client_content['beer']).to eq('variety' => 'cold')
  end

end
