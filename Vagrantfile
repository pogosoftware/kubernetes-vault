# -*- mode: ruby -*-
# vi: set ft=ruby :
dir      = File.dirname(File.expand_path(__FILE__))

require 'yaml'

instances = YAML.load_file("#{dir}/instances.yaml")
kubernetes_config = instances["kubernetes"]
vault_config = instances["vault"]

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

  config.vm.define "#{kubernetes_config['hostname']}" do |instance|
    instance.vm.network "private_network", ip: kubernetes_config['ip']
    instance.vm.hostname = kubernetes_config['hostname']

    instance.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = kubernetes_config['hostname']
      vb.cpus = kubernetes_config['cpus']
      vb.memory = kubernetes_config['memory']
    end

    instance.vm.provision "shell", path: "./scripts/update_vm.sh"
    instance.vm.provision "shell", path: "./scripts/#{kubernetes_config['hostname']}/install_microk8s.sh"
    instance.vm.provision "shell", path: "./scripts/#{kubernetes_config['hostname']}/install_helm.sh"
    instance.vm.provision "shell", path: "./scripts/#{kubernetes_config['hostname']}/install_helmfile.sh"

    instance.vm.provision "shell", path: "./scripts/#{kubernetes_config['hostname']}/vault-agent/deploy_vault_agent.sh"
  end

  config.vm.define "#{vault_config['hostname']}" do |instance|
    instance.vm.network "private_network", ip: vault_config['ip']
    instance.vm.hostname = vault_config['hostname']

    instance.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = vault_config['hostname']
      vb.cpus = vault_config['cpus']
      vb.memory = vault_config['memory']
    end

    instance.vm.provision "file", source: "./scripts/#{vault_config['hostname']}/vault/vault.hcl", destination: "/tmp/vault.hcl"
    instance.vm.provision "file", source: "./scripts/#{vault_config['hostname']}/vault/vault.service", destination: "/tmp/vault.service"
    instance.vm.provision "file", source: "./scripts/#{vault_config['hostname']}/terraform/main.tf", destination: "/tmp/main.tf"

    instance.vm.provision "shell", path: "./scripts/update_vm.sh"
    instance.vm.provision "shell", path: "./scripts/#{vault_config['hostname']}/vault/install_vault.sh"
    instance.vm.provision "shell", path: "./scripts/#{vault_config['hostname']}/terraform/install_terraform.sh"

    instance.vm.provision "shell", path: "./scripts/#{vault_config['hostname']}/terraform/provision_vault.sh"
  end

end
