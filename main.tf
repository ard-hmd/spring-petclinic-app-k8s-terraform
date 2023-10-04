provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "aws" {
  region = "eu-west-3" # Remplacez par votre région AWS si elle est différente
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "selected" {
  name = "eks-cluster-spring-petclinic"
}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  oidc_split     = split("/", data.aws_eks_cluster.selected.identity[0].oidc[0].issuer)
  oidc_id        = local.oidc_split[length(local.oidc_split) - 1]
}

# Création de la politique IAM pour le contrôleur ALB
resource "aws_iam_policy" "alb_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/iam_policy.json") # Assurez-vous que le fichier iam_policy.json est dans le même répertoire que votre fichier Terraform
}

resource "aws_iam_role" "alb_controller" {
  name               = "AmazonEKSLoadBalancerControllerRole"
  assume_role_policy = templatefile("${path.module}/load-balancer-role-trust-policy.json.tpl", {
    oidc_id       = local.oidc_id,
    aws_account_id = local.aws_account_id
  })
}

# Attachement de la politique au rôle
resource "aws_iam_role_policy_attachment" "alb_controller" {
  policy_arn = aws_iam_policy.alb_controller.arn
  role       = aws_iam_role.alb_controller.name
}

# Création du ServiceAccount Kubernetes pour le contrôleur ALB
resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name        = "aws-load-balancer-controller"
    namespace   = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
    }
  }
}

# Déploiement du contrôleur ALB en utilisant Helm
resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.6.1" # Vérifiez pour la version la plus récente

  set {
    name  = "clusterName"
    value = "eks-cluster-spring-petclinic" # Remplacez par le nom de votre cluster EKS
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.alb_controller.metadata[0].name
  }
}


data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name" # Remplacez par le nom de la balise appropriée si nécessaire
    values = ["prod-vpc"] # Remplacez par le nom de votre VPC
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
    name = "ingress.subnets"
    value = join("\\,", local.all_public_subnets)
  }

  values = [file("./spring-petclinic-chart/values.yaml")]

  depends_on = [helm_release.alb_controller]
}

