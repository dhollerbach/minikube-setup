locals {
  argocd = {
    password = bcrypt("admin")
  }
}

##########
# ARGOCD #
##########
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name      = "argocd"
  namespace = kubernetes_namespace.argocd.metadata.0.name

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  timeout    = 300

  values = [
    "${file("values.yaml")}"
  ]

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = local.argocd.password //  must be a bcrypt hashed password
  }
}
