provider "kubernetes" {
  config_path = "/home/ec2-user/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "/home/ec2-user/.kube/config"
  }
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "customers_db_mysql" {
  metadata {
    name      = "customers-db-mysql"
    namespace = var.namespace
  }

  data = {
    "mysql-root-password" = var.mysql_root_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "vets_db_mysql" {
  metadata {
    name      = "vets-db-mysql"
    namespace = var.namespace
  }

  data = {
    "mysql-root-password" = var.mysql_root_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "visits_db_mysql" {
  metadata {
    name      = "visits-db-mysql"
    namespace = var.namespace
  }

  data = {
    "mysql-root-password" = var.mysql_root_password
  }

  type = "Opaque"
}

resource "helm_release" "my_release" {
  name      = "my-release" // Nom de la release Helm
  namespace = var.namespace
  chart     = "./spring-petclinic-chart" // Chemin relatif vers le dossier du chart Helm
  version   = "1.0.0" // Version du Helm chart à déployer
  
  set {
    name  = "namespace"
    value = var.namespace
  }
  set {
    name  = "repository_prefix"
    value = var.repository_prefix
  }
  values = [file("./spring-petclinic-chart/values.yaml")] // Chemin relatif vers le fichier values.yaml
}

data "kubernetes_service" "api_gateway" {
  depends_on = [helm_release.my_release]
  metadata {
    name      = "api-gateway"
    namespace = var.namespace
  }
}

output "api_gateway_url" {
  value = data.kubernetes_service.api_gateway.status[0].load_balancer[0].ingress[0].hostname != null ? data.kubernetes_service.api_gateway.status[0].load_balancer[0].ingress[0].hostname : "Hostname not available"
}