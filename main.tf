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

module "helm_petclinic_module" {
  source = "./modules/helm-petclinic-module"

  vpc_name              = "prod-vpc"
  az_a_subnet_name      = "prod-eu-west-3a-public-subnet"
  az_b_subnet_name      = "prod-eu-west-3b-public-subnet"
  namespace             = var.namespace
  mysql_root_password   = var.mysql_root_password
  helm_chart_version    = "1.2.3"
  helm_chart_path       = "./spring-petclinic-chart"
  helm_values_file      = "./spring-petclinic-chart/values.yaml"
  helm_release_name     = "petclinic-qa"

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

  depends_on = [module.helm_petclinic_module]
}