provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Resource to create a Kubernetes namespace
resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.namespace
  }
}

# Resource to create a Kubernetes secret for storing the MySQL root password for the customers database
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

# Resource to create a Kubernetes secret for storing the MySQL root password for the vets database
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

# Resource to create a Kubernetes secret for storing the MySQL root password for the visits database
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

# Resource to deploy a Helm release for the Spring PetClinic application
resource "helm_release" "my_release" {
  name      = "my-release"
  namespace = var.namespace
  chart     = "./spring-petclinic-chart"
  version   = "1.0.0"
  
  set {
    name  = "namespace"
    value = var.namespace
  }
  set {
    name  = "repository_prefix"
    value = var.repository_prefix
  }
  values = [file("./spring-petclinic-chart/values.yaml")]
}

# Data resource to get information about the deployed API Gateway service
data "kubernetes_service" "api_gateway" {
  depends_on = [helm_release.my_release]
  metadata {
    name      = "api-gateway"
    namespace = var.namespace
  }
}

# # Output the hostname of the API Gateway service, if available
# # output "api_gateway_url" {
# #   value = data.kubernetes_service.api_gateway.status[0].load_balancer[0].ingress[0].hostname != null ? data.kubernetes_service.api_gateway.status[0].load_balancer[0].ingress[0].hostname : "Hostname not available"
# # }
