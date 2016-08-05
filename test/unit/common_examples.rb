RSpec.shared_examples 'sensu default recipe' do
  it "installs the Sensu package" do
    expect(chef_run).to install_package(sensu_pkg_name)
  end

  it "creates the log directory" do
    expect(chef_run).to create_directory(log_directory).with(
      :owner => 'sensu',
      :group => 'sensu',
      :recursive => true,
      :mode => "0750"
    )
  end

  %w[
      conf.d
      plugins
      handlers
      extensions
    ].each do |dir|
    it "creates the #{dir} directory" do
      expect(chef_run).to create_directory(File.join(sensu_directory, dir))
    end
  end

  let(:ssl_cert_chain_file) { File.join(sensu_directory, 'ssl', 'cert.pem') }
  let(:ssl_private_key_file) { File.join(sensu_directory, 'ssl', 'key.pem') }

  context 'ssl is enabled' do
    it "writes the certificate chain file" do
      expect(chef_run).to create_file(ssl_cert_chain_file)
    end

    it "writes the private key file" do
      expect(chef_run).to create_file(ssl_private_key_file)
    end
  end

  context 'ssl is disabled' do

    before do
      chef_run.node.override["sensu"]["use_ssl"] = false
      chef_run.converge(described_recipe)
    end

    it "does not write the certificate chain file" do
      expect(chef_run).to_not create_file(ssl_cert_chain_file)
    end

    it "does not write the private key file" do
      expect(chef_run).to_not create_file(ssl_private_key_file)
    end
  end

  it "writes a base sensu configuration using sensu_base_config" do
    expect(chef_run).to create_sensu_base_config(chef_run.node.name)
  end

end
