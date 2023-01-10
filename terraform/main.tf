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

  //  ingress configuration
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/force-ssl-redirect"
    value = "true"
  }

  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ssl-passthrough"
    value = "true"
  }

  set {
    name  = "server.ingress.enabled"
    value = "true"
  }

  set {
    name  = "server.ingress.hosts"
    value = "{localhost}"
  }

  set {
    name  = "server.service.type"
    value = "LoadBalancer" //  sets argocd server service type to LoadBalancer. This is required when running on Mac M1s
  }

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = local.argocd.password //  must be a bcrypt hashed password
  }
}
