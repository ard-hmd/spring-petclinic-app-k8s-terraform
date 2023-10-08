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
  for_each = toset(var.namespace)

  source = "./modules/helm-petclinic-module"

  # Variables specific to the helm-petclinic-module
  vpc_name            = var.vpc_name
  az_a_subnet_name    = var.az_a_subnet_name
  az_b_subnet_name    = var.az_b_subnet_name
  namespace           = [each.value]
  mysql_root_password = var.mysql_root_password
  repository_prefix   = var.repository_prefix

  # Variables for the API Gateway service
  domain_name = var.domain_name
  record_name = "${var.record_name}-${each.value}"
  api_gateway_service_release_name  = var.api_gateway_service_release_name
  api_gateway_service_chart_path    = var.api_gateway_service_chart_path
  api_gateway_service_chart_version = var.api_gateway_service_chart_version
  api_gateway_service_values_file   = var.api_gateway_service_values_file
  alb_name                          = "${var.alb_name}-${each.value}"
  # fqdn                              = var.fqdn
  fqdn                              = "${var.record_name}-${each.value}.${var.dname}"
  certificateArn                    = var.certificateArn

  # Variables for the Customers service
  customers_service_release_name  = var.customers_service_release_name
  customers_service_chart_path    = var.customers_service_chart_path
  customers_service_chart_version = var.customers_service_chart_version
  customers_service_values_file   = var.customers_service_values_file
  customers_dbhost                = var.customers_dbhost
  customers_dbname                = var.customers_dbname
  customers_dbuser                = var.customers_dbuser

  # Variables for the Visits service
  visits_service_release_name  = var.visits_service_release_name
  visits_service_chart_path    = var.visits_service_chart_path
  visits_service_chart_version = var.visits_service_chart_version
  visits_service_values_file   = var.visits_service_values_file
  visits_dbhost                = var.visits_dbhost
  visits_dbname                = var.visits_dbname
  visits_dbuser                = var.visits_dbuser

  # Variables for the Vets service
  vets_service_release_name  = var.vets_service_release_name
  vets_service_chart_path    = var.vets_service_chart_path
  vets_service_chart_version = var.vets_service_chart_version
  vets_service_values_file   = var.vets_service_values_file
  vets_dbhost                = var.vets_dbhost
  vets_dbname                = var.vets_dbname
  vets_dbuser                = var.vets_dbuser

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
  for_each = toset(var.namespace)

  source = "./modules/aws-route53-module"

  # Variables specific to the aws-route53-module
  alb_name    = "${var.alb_name}-${each.value}"
  domain_name = var.domain_name
  record_name = "${var.record_name}-${each.value}"
  namespace   = [each.value]

  depends_on = [module.helm_petclinic_module]
}
























# # Module for AWS ALB Controller
# module "alb_controller_module" {
#   source = "./modules/aws-alb-controller-module"

#   # Variables specific to the aws-alb-controller-module
#   eks_cluster_name         = var.eks_cluster_name
#   alb_controller_role_name = var.alb_controller_role_name
#   alb_controller_version   = var.alb_controller_version
# }

# # Module for Helm deployment of PetClinic application
# module "helm_petclinic_module" {
#   source = "./modules/helm-petclinic-module"

#   # Variables specific to the helm-petclinic-module
#   vpc_name            = var.vpc_name
#   az_a_subnet_name    = var.az_a_subnet_name
#   az_b_subnet_name    = var.az_b_subnet_name
#   namespace           = var.namespace
#   mysql_root_password = var.mysql_root_password
#   repository_prefix   = var.repository_prefix

#   # Variables for the API Gateway service
#   api_gateway_service_release_name  = var.api_gateway_service_release_name
#   api_gateway_service_chart_path    = var.api_gateway_service_chart_path
#   api_gateway_service_chart_version = var.api_gateway_service_chart_version
#   api_gateway_service_values_file   = var.api_gateway_service_values_file
#   alb_name                          = var.alb_name
#   fqdn                              = var.fqdn
#   certificateArn                    = var.certificateArn

#   # Variables for the Customers service
#   customers_service_release_name  = var.customers_service_release_name
#   customers_service_chart_path    = var.customers_service_chart_path
#   customers_service_chart_version = var.customers_service_chart_version
#   customers_service_values_file   = var.customers_service_values_file
#   customers_dbhost                = var.customers_dbhost
#   customers_dbname                = var.customers_dbname
#   customers_dbuser                = var.customers_dbuser

#   # Variables for the Visits service
#   visits_service_release_name  = var.visits_service_release_name
#   visits_service_chart_path    = var.visits_service_chart_path
#   visits_service_chart_version = var.visits_service_chart_version
#   visits_service_values_file   = var.visits_service_values_file
#   visits_dbhost                = var.visits_dbhost
#   visits_dbname                = var.visits_dbname
#   visits_dbuser                = var.visits_dbuser

#   # Variables for the Vets service
#   vets_service_release_name  = var.vets_service_release_name
#   vets_service_chart_path    = var.vets_service_chart_path
#   vets_service_chart_version = var.vets_service_chart_version
#   vets_service_values_file   = var.vets_service_values_file
#   vets_dbhost                = var.vets_dbhost
#   vets_dbname                = var.vets_dbname
#   vets_dbuser                = var.vets_dbuser

#   depends_on = [module.alb_controller_module]
# }


# # Null resource for introducing sleep (useful for waiting)
# resource "null_resource" "sleep" {
#   triggers = {
#     always_run = timestamp()
#   }

#   provisioner "local-exec" {
#     command = "sleep 60"
#   }
#   depends_on = [module.alb_controller_module]
# }

# # Module for managing AWS Route53 records
# module "aws_route53_module" {
#   source = "./modules/aws-route53-module"

#   # Variables specific to the aws-route53-module
#   alb_name    = var.alb_name
#   domain_name = var.domain_name
#   record_name = var.record_name

#   depends_on = [module.helm_petclinic_module]
# }
