#!/bin/bash -eux

pushd /home/vagrant
mv /tmp/main.tf .

export VAULT_TOKEN=`cat /vagrant/secrets/vault_root.token`
sed -i s/VAULT_TOKEN/$VAULT_TOKEN/g main.tf

terraform init
terraform plan -out tfplan
terraform apply tfplan