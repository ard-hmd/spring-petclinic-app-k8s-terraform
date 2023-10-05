provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "aws" {
  region = "eu-west-3"
}

module "alb_controller_module" {
  source = "./modules/aws-alb-controller-module"

  eks_cluster_name         = "eks-cluster-spring-petclinic"
  alb_controller_role_name = "AmazonEKSLoadBalancerControllerRole"
  alb_controller_version   = "1.6.1"
}

data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["prod-vpc"]
  }
}

data "aws_subnet" "public_subnets_a" {
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name = "prod-eu-west-3a-public-subnet"
  }
}

data "aws_subnet" "public_subnets_b" {
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name = "prod-eu-west-3b-public-subnet"
  }
}

locals {
  all_public_subnets = [data.aws_subnet.public_subnets_a.id, data.aws_subnet.public_subnets_b.id]
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
  set {
    name  = "ingress.subnets"
    value = join("\\,", local.all_public_subnets)
  }

  values = [file("./spring-petclinic-chart/values.yaml")]

  depends_on = [module.alb_controller_module]
}

resource "null_resource" "sleep" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }
  depends_on = [module.alb_controller_module]
}

module "route53" {
  source = "./modules/aws-route53-module"

  alb_name    = "mon-alb-petclinic"
  domain_name = "ahermand.fr."
  record_name = "www"

  depends_on = [helm_release.my_release]
}