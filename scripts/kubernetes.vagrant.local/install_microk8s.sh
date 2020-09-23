#!/bin/bash -eux

snap install microk8s --classic --channel=1.19
microk8s status --wait-ready

microk8s enable dns storage

usermod -a -G microk8s vagrant
chown -f -R vagrant ~/.kube

snap install kubectl --channel=1.19/stable --classic
microk8s config > ~/.kube/config