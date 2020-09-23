#!/bin/bash -eux

wget --quiet https://releases.hashicorp.com/terraform/0.13.3/terraform_0.13.3_linux_amd64.zip
unzip terraform_0.13.3_linux_amd64.zip
mv terraform /usr/local/bin/terraform
chmod +x /usr/local/bin/terraform