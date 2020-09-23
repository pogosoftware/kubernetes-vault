# Kubernetes Vault
This is example how to use vault kubernetes authentication, access to the secrets and injecting them to the pod.

# Provision

## Requirements

* Vagrant
* VirtualBox

## Setup infrastructure

```bash
git clone https://github.com/pogosoftware/kubernetes-vault
cd kubernetes-vault
vagrant up
```

This will create 2 virtual machines: kubernetes and vault

## Deploying application

```bash
vagrant ssh kubernetes.vagrant.local
cd /vagrant/secrets/kubernetes.vagrant.local/app
kubectl apply -f deployment.yaml
```

When application will be up and running the execute below command to check if the secrets are properly injected to the pod
```bash
kubectl exec $(kubectl get pod -l app=orgchart -o jsonpath="{.items[0].metadata.name}") --container orgchart -- cat /vault/secrets/database-config.txt
```

# Links

* [Vault Kubernetes Agent](https://learn.hashicorp.com/tutorials/vault/agent-kubernetes)
* [Vault Agent Injector](https://www.vaultproject.io/docs/platform/k8s/injector)
* [Kubernetes sidecar](https://learn.hashicorp.com/tutorials/vault/kubernetes-sidecar)
