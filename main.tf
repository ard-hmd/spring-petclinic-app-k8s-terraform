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
  fqdn                              = "${var.record_name}-${each.value}.${var.cleaned_domain_name}"
  certificateArn                    = var.certificateArn

  # Variables for the Inital Config
  inital_config_release_name  = var.inital_config_release_name
  inital_config_chart_path    = var.inital_config_chart_path
  inital_config_chart_version = var.inital_config_chart_version
  inital_config_values_file   = var.inital_config_values_file

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

module "monitoring_module" {
  source = "./modules/monitoring-module"

  vpc_name                    = var.vpc_name
  az_a_subnet_name            = var.az_a_subnet_name
  az_b_subnet_name            = var.az_b_subnet_name
  alb_grafana_release_name    = var.alb_grafana_release_name
  alb_grafana_chart_path      = var.alb_grafana_chart_path
  alb_grafana_chart_version   = var.alb_grafana_chart_version
  alb_grafana_values_file     = var.alb_grafana_values_file
  alb_grafana_record_name     = var.alb_grafana_record_name
  alb_grafana_domain_name     = var.alb_grafana_domain_name
  alb_grafana_alb_name        = "${var.alb_grafana_alb_name}"
  alb_grafana_cleaned_domain_name = var.alb_grafana_cleaned_domain_name
  alb_grafana_fqdn            = "${var.alb_grafana_record_name}.${var.alb_grafana_cleaned_domain_name}"
  alb_grafana_certificateArn  = var.alb_grafana_certificateArn
}






















# resource "kubernetes_namespace" "prometheus" {
#   metadata {
#     name = "prometheus"
#   }
# }

# resource "helm_release" "prometheus" {
#   name       = "prometheus"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "prometheus"
#   namespace  = kubernetes_namespace.prometheus.metadata[0].name

#   set {
#     name  = "alertmanager.persistentVolume.storageClass"
#     value = "gp2"
#   }

#   set {
#     name  = "server.persistentVolume.storageClass"
#     value = "gp2"
#   }

#   depends_on = [kubernetes_namespace.prometheus]
# }

# # Créez le namespace Grafana
# resource "kubernetes_namespace" "grafana" {
#   metadata {
#     name = "grafana"
#   }
# }

# # Configuration du ConfigMap pour Grafana
# resource "kubernetes_config_map" "grafana_config" {
#   metadata {
#     name      = "grafana-config"
#     namespace = kubernetes_namespace.grafana.metadata[0].name
#   }

#   data = {
#     "datasources.yaml" = <<-EOT
#       datasources:
#         datasources.yaml:
#           apiVersion: 1
#           datasources:
#             - name: Prometheus
#               type: prometheus
#               url: http://prometheus-server.prometheus.svc.cluster.local
#               access: proxy
#               isDefault: true
#     EOT
#   }

#   depends_on = [kubernetes_namespace.grafana]
# }

# # Installation de Grafana avec Helm
# resource "helm_release" "grafana" {
#   name       = "grafana"
#   repository = "https://grafana.github.io/helm-charts"
#   chart      = "grafana"
#   namespace  = kubernetes_namespace.grafana.metadata[0].name

#   set {
#     name  = "persistence.storageClass"
#     value = "gp2"
#   }

#   set {
#     name  = "persistence.enabled"
#     value = "true"
#   }

#   set {
#     name  = "adminPassword"
#     value = "YOUR_PASSWORD"  # Remplacez par votre mot de passe d'administration Grafana
#   }

#   set {
#     name  = "service.type"
#     value = "NodePort"
#   }

#   depends_on = [kubernetes_namespace.grafana, kubernetes_config_map.grafana_config]
# }

# resource "helm_release" "alb_grafana" {
#   name       = "alb-grafana-release"  # Nom de votre déploiement Helm
#   chart      = "./spring-petclinic-charts/alb-grafana"  # Nom du chart à déployer
#   namespace  = "grafana"  # Le namespace Kubernetes dans lequel vous souhaitez déployer le chart
# }