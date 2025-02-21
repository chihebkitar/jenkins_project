Vagrant.configure("2") do |config|
    config.vm.define "jenkins" do |jenkins|
      # Use official Ubuntu 20.04 box
      jenkins.vm.box = "ubuntu/focal64"
      jenkins.vm.network "private_network", type: "static", ip: "192.168.56.5"
      jenkins.vm.hostname = "jenkins"
      jenkins.vm.provider "virtualbox" do |v|
        v.name = "jenkins"
        v.memory = 6144
        v.cpus = 2
      end
    end
  end
