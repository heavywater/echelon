Vagrant::Config.run do |config|
  config.vm.define :echelon do |echelon|
    echelon.vm.customize do |vm|
      vm.memory_size = ENV["ECHELON_RAM"] || 4096
      vm.cpus = ENV["ECHELON_CPUS"] || 2
    end
    echelon.vm.box = "precise64"
    echelon.vm.box_url = "https://s3.amazonaws.com/hw-vagrant/precise64.box"
    echelon.vm.forward_port 80, 8000
    echelon.vm.forward_port 8080, 8080
    echelon.vm.forward_port 9001, 9001
    echelon.vm.forward_port 9292, 9292
    echelon.vm.provision :chef_solo do |chef|
      chef.data_bags_path = "data_bags"
      chef.cookbooks_path = "cookbooks"
      chef.roles_path = "roles"
      chef.add_role "echelon"
    end
  end
end
