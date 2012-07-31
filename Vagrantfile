memory = ENV["ECHELON_RAM"] || 4096
cpus = ENV["ECHELON_CPUS"] || 2

Vagrant::Config.run do |config|
  config.vm.define 'ubuntu-12.04' do |c|
    c.vm.box     = "opscode-ubuntu-12.04"
    c.vm.box_url = "http://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-12.04.box"
  end

  config.vm.customize ["modifyvm", :id, "--memory", memory]
  config.vm.customize ["modifyvm", :id, "--cpus", cpus]

  config.vm.forward_port 80, 8000
  config.vm.forward_port 8080, 8080
  config.vm.forward_port 9001, 9001
  config.vm.forward_port 9292, 9292 # gdash
  config.vm.provision :chef_solo do |chef|
    chef.data_bags_path = "data_bags"
    chef.cookbooks_path = "cookbooks"
    chef.roles_path = "roles"
    chef.add_role "echelon"
    chef.json = {
      :logstash => {
        :agent => {
          :server_ipaddress => "127.0.0.1"
        },
        :elasticsearch_ip => "127.0.0.1",
        :graphite_ip => "127.0.0.1"
      }
    }
  end
end
