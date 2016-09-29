data_bag_name = node["sensu"]["data_bag"]["name"]
enterprise_item = node["sensu"]["data_bag"]["enterprise_item"]

begin
  unless get_sensu_state(node, "enterprise")
    enterprise = Sensu::Helpers.data_bag_item(enterprise_item, true, data_bag_name)
    set_sensu_state(node, "enterprise", enterprise)
   end
rescue => e
  Chef::Log.warn("Failed to populate Sensu state with Enterprise repository credentials from data bag: " + e.inspect)
end

credentials = get_sensu_state(node, "enterprise", "repository", "credentials")

repository_url = case credentials.nil?
                 when true
                   "#{node["sensu"]["enterprise"]["repo_protocol"]}://#{node["sensu"]["enterprise"]["repo_host"]}"
                 when false
                   "#{node["sensu"]["enterprise"]["repo_protocol"]}://#{credentials['user']}:#{credentials['password']}@#{node["sensu"]["enterprise"]["repo_host"]}"
                 end

case node["platform_family"]
when "debian"
  include_recipe "apt"

  apt_repository "sensu-enterprise" do
    uri File.join(repository_url, "apt")
    key File.join(repository_url, "apt", "pubkey.gpg")
    distribution "sensu-enterprise"
    components node["sensu"]["enterprise"]["use_unstable_repo"] ? ["unstable"] : ["main"]
    action :add
  end
else
  { "sensu-enterprise" => "noarch", "sensu-enterprise-dashboard" => "$basearch" }.each_pair do |repo_name, arch|
    repo = yum_repository repo_name do
      description repo_name
      channel = node["sensu"]["enterprise"]["use_unstable_repo"] ? "yum-unstable" : "yum"
      url "#{repository_url}/#{channel}/#{arch}/"
      action :add
    end
    repo.gpgcheck(false) if repo.respond_to?(:gpgcheck)
  end
end
