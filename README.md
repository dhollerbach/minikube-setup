# Overview

This repository aims to simplify installing Minikube and some common DevOps packages on a Mac or Linux distribution. After running the below steps, you will have a fully functional Minikube environment with the option to install to a number of applications through ArgoCD, including Vault, Consul, and more! Additional applications will be added as needed.

## Prerequisites

The `setup.sh` script makes extensive use of [Homebrew](https://brew.sh/) to install dependencies and packages and to run Minikube. This script will attempt to install Homebrew for you if desired. Otherwise, install [Homebrew](https://brew.sh/) manually.

## Installation

To begin your local setup, clone this repository and cd into your newly cloned repository.

```
git@github.com:dhollerbach/minikube-setup.git

cd minikube-setup/
```

### Step 1: Install Minikube and DevOps Tools

To install Minikube and its associated DevOps tools, run the following script:

```
./setup.sh
```

DevOps Tools Installed:
- argocd
- awscli
- bcrypt
- docker
- helm
- k9s
- kubernetes-cli
- minikube
- terraform
- vault

This script will install Minikube, configure a few addons (ingress / metrics-server), install some DevOps tools, and open a tunnel to your localhost. Upon successful completion, you will be prompted for your password so that Minikube can establish a tunnel to your localhost as previously mentioned. Running `minikube tunnel` is the primary difference when using arm64 processors as other processors do not usually require this step. If you ever lose your tunnel connection - like if you close your terminal - you can reestablish the tunnel by opening a new terminal and running the following command:

```
sudo minikube tunnel
```

### Step 2: Run Terraform

To run Terraform against Minikube, make sure you have your Minikube Kubernetes context selected. Your Minikube Kubernetes context should already be selected if you just ran the script above but in case it's not, or to select Minikube as your Kubernetes context in general, run the following command:

```
kubectl config use-context minikube
```

Now with your Minikube Kubernetes context selected, run Terraform with the following commands:

```
cd terraform/

terraform init

terraform apply
```

Terraform simply creates a Kubernetes namespace for ArgoCD called `argocd` and then installs ArgoCD using Helm. Once Terraform is finishes successfully, ensure your `minikube tunnel` is still running or rerun it if needed. Then, login to ArgoCD using [localhost](https://localhost) - the certificate error is expected and safe to ignore since we are using a self-signed certificate for our localhost setup. The default credentials to login to ArgoCD are:

```
Username: admin

Password: admin
```

### Step 3: Install Applications Using ArgoCD

There are a number of applications provided in the `argocd` directory that can be installed into your Minikube environment. To install all of these applications, run the following command:

```
kubectl apply -f argocd/
```

To run a specified file rather than all files in the `argocd` directory, run the following command:

```
kubectl apply -f argocd/<FILENAME>  # like argocd/helm-kube-state-metrics.yaml
```

| ArgoCD Package          | Install Steps |
| --------------          | ------------- |
| helm-consul             | kubectl apply -f argocd/helm-consul.yaml |
| helm-kube-state-metrics | kubectl apply -f argocd/helm-kube-state-metrics.yaml |
| helm-postgresql         | kubectl apply -f argocd/helm-postgresql.yaml |
| helm-redis              | kubectl apply -f argocd/helm-redis.yaml |
| helm-vault              | kubectl apply -f argocd/helm-vault.yaml<ul><li>Browse to [localhost:8200](http://localhost:8200)</li><li>Under `Key shares`, type "1"</li><li>Under `Key threshold`, type "1"</li><li>Click `Initialize`</li><li>Click `Download keys`</li><li>Click `Continue to Unseal`</li><li>Under `Unseal Key Portion`, enter the unseal key that you downloaded</li><li>Click `Unseal`</li><li>Under `Token`, enter the root token that you downloaded</li><li>Click `Sign In`</li></ul> |

## Delete Minikube Environment

To delete your Minikube environment, simply run the following command to remove your entire environment:

```
minikube delete
```

**PLEASE NOTE THIS IS A DESTRUCTIVE ACTION AND WILL DESTROY ALL OF YOUR WORK, INCLUDING VAULT SECRETS!!!
