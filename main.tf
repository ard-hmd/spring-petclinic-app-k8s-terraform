provider "kubernetes" {
  config_path = "/home/ec2-user/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "/home/ec2-user/.kube/config"
  }
}

resource "kubernetes_namespace" "qa" {
  metadata {
    name = "qa"
  }
}

variable "mysql_root_password" {
  description = "The MySQL root password."
  default     = "password" // Remplacez par la valeur souhaitée
}

resource "kubernetes_secret" "customers_db_mysql" {
  metadata {
    name      = "customers-db-mysql"
    namespace = kubernetes_namespace.qa.metadata[0].name
  }

  data = {
    "mysql-root-password" = var.mysql_root_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "vets_db_mysql" {
  metadata {
    name      = "vets-db-mysql"
    namespace = kubernetes_namespace.qa.metadata[0].name
  }

  data = {
    "mysql-root-password" = var.mysql_root_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "visits_db_mysql" {
  metadata {
    name      = "visits-db-mysql"
    namespace = kubernetes_namespace.qa.metadata[0].name
  }

  data = {
    "mysql-root-password" = var.mysql_root_password
  }

  type = "Opaque"
}

resource "helm_release" "my_release" {
  name      = "my-release" // Nom de la release Helm
  namespace = kubernetes_namespace.qa.metadata[0].name
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
