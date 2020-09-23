#!/bin/bash -eux

echo "Deploying Vault Agent Injector..."
pushd /vagrant/scripts/kubernetes.vagrant.local/vault-agent
/usr/local/bin/helmfile sync

echo "Exporting Vault Agent Injector token and certificate..."
mkdir -p /vagrant/secrets
pushd /vagrant/secrets

export VAULT_SA_NAME=$(kubectl -n kube-public get sa vault-agent-injector -o jsonpath="{.secrets[*]['name']}")
kubectl -n kube-public get secret $VAULT_SA_NAME -o jsonpath="{.data.token}" | base64 --decode > vault_agent.token
kubectl -n kube-public get secret $VAULT_SA_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode > vault_agent.crt