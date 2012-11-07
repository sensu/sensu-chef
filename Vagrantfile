require 'berkshelf/vagrant'

Vagrant::Config.run do |config|
  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-12.04.box"
  config.vm.customize [
    "modifyvm", :id,
    "--name", "Sensu Stack",
    "--memory", "1024"
  ]

  config.vm.forward_port 8080, 8080
  config.vm.forward_port 9000, 9000

  config.vm.provision :chef_solo do |chef|
    chef.data_bags_path = "examples/data_bags"
    chef.roles_path = "examples/roles"
    chef.add_role("vagrant")
  end
end
