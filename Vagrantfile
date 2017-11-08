Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "ifeReader"
    vb.memory = "512"
  end

  
  config.vm.network "forwarded_port", guest: 80, host: 8000
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  config.vm.provision :shell, path: "./provision/bootstrap.sh"
  config.vm.synced_folder "project/", "/home/vagrant/project"
end