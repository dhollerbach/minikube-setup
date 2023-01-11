#!/bin/bash

set -e

########
# BREW #
########
# install packages
brew install \
    argocd \
    awscli \
    bcrypt \
    helm \
    k9s \
    kubernetes-cli \
    minikube \
    terraform \
    tfenv \
    vault

# links tfenv for switching between Terraform versions
brew unlink terraform
brew link tfenv

############
# MINIKUBE #
############
# start minikube and enable addons
minikube start --memory 4096 --cpus 4
minikube addons enable ingress
minikube addons enable metrics-server

# start minikube tunnel
echo "Starting minikube tunnel..."
sudo minikube tunnel
