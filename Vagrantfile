# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  # Setup Ubuntu Server to monitor
  config.vm.define "Ubuntu-01" do |node|

    node.vm.box = "generic/ubuntu2004"
    node.vm.box_check_update = false
    node.vm.box_version = "3.1.12"
    node.vm.hostname = "monitor-client"
    node.vm.network "private_network", ip: "172.16.16.101"

    #Default Provider
    node.vm.provider "virtualbox" do |v|
      v.name = "Ubuntu-01"
      v.memory = 1024
      v.cpus = 1
    end

    node.vm.provision "shell", path: "node_exporter_setup.sh"
  end

  # Grafana and Promethus Server
  config.vm.define "Grafana" do |node|
  
    node.vm.box = "generic/ubuntu2004"
    node.vm.box_check_update = false
    node.vm.box_version = "3.1.12"
    node.vm.hostname = "monitor-server"
    node.vm.network "private_network", ip: "172.16.16.100"
  
    #Default Provider
    node.vm.provider "virtualbox" do |v|
      v.name = "Grafana"
      v.memory = 2048
      v.cpus = 2
    end
  
    node.vm.provision "shell", path: "prom_grafana_setup.sh"
  end

  
end