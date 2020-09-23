#!/bin/bash -eux

apt-get install -y unzip jq

wget --quiet https://releases.hashicorp.com/vault/1.5.3/vault_1.5.3_linux_amd64.zip
unzip vault_1.5.3_linux_amd64.zip
mv vault /usr/local/bin/vault
chmod +x /usr/local/bin/vault

setcap cap_ipc_lock=+ep /usr/local/bin/vault

useradd --system --home /etc/vault.d --create-home --shell /bin/false vault

mkdir -p /var/lib/vault
chown -R vault:vault /var/lib/vault

mv /tmp/vault.hcl /etc/vault.d/vault.hcl
mv /tmp/vault.service /etc/systemd/system/vault.service

systemctl daemon-reload
systemctl enable vault.service
systemctl start vault.service

sleep 10s

mkdir -p /vagrant/secrets
pushd /vagrant/secrets

echo "Waiting to Vault..."
export VAULT_ADDR=http://192.168.33.11:8200
export VAULT_STATUS=`vault operator init -status`
if [[ "$VAULT_STATUS" != "Vault is initialized" ]]
then
  echo "Exporting vault keys..."
  VAULT_RESULT=`vault operator init -key-shares=1 -key-threshold=1 -format json`
  
  echo $VAULT_RESULT | jq --raw-output '.root_token' > vault_root.token
  export UNSEAL_TOKEN=`echo $VAULT_RESULT | jq --raw-output '.unseal_keys_hex[0]'`
  echo $UNSEAL_TOKEN > vault_unseal.keys

  echo "Unsealing vault..."
  vault operator unseal $UNSEAL_TOKEN
fi