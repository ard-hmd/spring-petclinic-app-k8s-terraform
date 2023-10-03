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
  name      = "petclinic-release"
  namespace = var.namespace
  chart     = "./spring-petclinic-chart"
  version   = "1.0.0"
  
  set {
    name  = "namespace"
    value = var.namespace
  }

  values = [file("./spring-petclinic-chart/values.yaml")]
}

data "kubernetes_ingress" "api_gateway_ingress" {
  metadata {
    name      = "api-gateway-ingress"
    namespace = var.namespace
  }
}

output "elb_hostname" {
  value = data.kubernetes_ingress.api_gateway_ingress.status.0.load_balancer.0.ingress.0.hostname
}
