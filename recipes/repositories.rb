#
# Cookbook:: sensu
# Recipe:: repositories
#
# Copyright:: 2017, The Authors, All Rights Reserved.

if node['sensu']['repositories']['packagecloud']['token']
  # Install via packagecloud.io if a token is provided
  execute 'install_repos_for_packagecloud' do
    command 'curl -s https://$SENSU_REPO_TOKEN:@packagecloud.io/install/repositories/sensu/prerelease/script.rpm.sh | bash'
    creates '/etc/yum.repos.d/sensu_prerelease.repo'
    user 'root'
    environment ({'SENSU_REPO_TOKEN' => node['sensu']['repositories']['packagecloud']['token']})
    action :run
  end
else
  yum_repository 'sensu' do
    description 'Sensu Repository'
    baseurl node['sensu']['repositories']['yum']['url']
    gpgkey node['sensu']['repositories']['yum']['url'] + '/gpgkey'
    repo_gpgcheck true
    gpgcheck true
    enabled true
    sslverify true
    metadata_expire '300'
    action :create
  end
end



