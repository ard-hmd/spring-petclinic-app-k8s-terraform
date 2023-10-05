# Module for AWS ALB Controller
module "alb_controller_module" {
  source = "./modules/aws-alb-controller-module"

  # Variables specific to the aws-alb-controller-module
  eks_cluster_name         = var.eks_cluster_name
  alb_controller_role_name = var.alb_controller_role_name
  alb_controller_version   = var.alb_controller_version
}

# Module for Helm deployment of PetClinic application
module "helm_petclinic_module" {
  source = "./modules/helm-petclinic-module"

  # Variables specific to the helm-petclinic-module
  vpc_name              = var.vpc_name
  az_a_subnet_name      = var.az_a_subnet_name
  az_b_subnet_name      = var.az_b_subnet_name
  namespace             = var.namespace
  mysql_root_password   = var.mysql_root_password
  helm_chart_version    = var.helm_chart_version
  helm_chart_path       = var.helm_chart_path
  helm_values_file      = var.helm_values_file
  helm_release_name     = var.helm_release_name
  alb_name              = var.alb_name
  repository_prefix     = var.repository_prefix
  certificateArn        = var.certificateArn
  fqdn                  = var.fqdn

  # Variables for database configuration
  customers_dbhost      = var.customers_dbhost
  customers_dbname      = var.customers_dbname
  customers_dbuser      = var.customers_dbuser
  visits_dbhost         = var.visits_dbhost
  visits_dbname         = var.visits_dbname
  visits_dbuser         = var.visits_dbuser
  vets_dbhost           = var.vets_dbhost
  vets_dbname           = var.vets_dbname
  vets_dbuser           = var.vets_dbuser

  depends_on = [module.alb_controller_module]
}


# Null resource for introducing sleep (useful for waiting)
resource "null_resource" "sleep" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "sleep 60"
  }
  depends_on = [module.alb_controller_module]
}

# Module for managing AWS Route53 records
module "aws_route53_module" {
  source = "./modules/aws-route53-module"

  # Variables specific to the aws-route53-module
  alb_name    = var.alb_name
  domain_name = var.domain_name
  record_name = var.record_name

  depends_on = [module.helm_petclinic_module]
}
