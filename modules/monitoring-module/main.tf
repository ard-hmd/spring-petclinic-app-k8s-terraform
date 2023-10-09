resource "null_resource" "helm_repos" {
  provisioner "local-exec" {
    command = <<EOT
      helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
      helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
      helm repo add grafana https://grafana.github.io/helm-charts
      helm repo update
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

# Création du namespace pour Prometheus
resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
  }
}

# Installation de Prometheus via Helm
resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = kubernetes_namespace.prometheus.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"

  set {
    name  = "alertmanager.persistentVolume.storageClass"
    value = "gp2"
  }

  set {
    name  = "server.persistentVolume.storageClass"
    value = "gp2"
  }
}

# Création du namespace pour Grafana
resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "grafana"
  }
}

# Installation de Grafana via Helm
resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = kubernetes_namespace.grafana.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"

  set {
    name  = "persistence.storageClass"
    value = "gp2"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "adminPassword"
    value = "password"
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  values = [file("${path.module}/grafana.yaml")]
}

# Data Sources
# These data sources retrieve existing resources.

# Retrieve the existing VPC with the specified tags
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# Retrieve public subnets in Availability Zone A
data "aws_subnet" "public_subnets_a" {
  vpc_id = data.aws_vpc.existing_vpc.id
  tags = {
    Name = var.az_a_subnet_name
  }
}

# Retrieve public subnets in Availability Zone B
data "aws_subnet" "public_subnets_b" {
  vpc_id = data.aws_vpc.existing_vpc.id
  tags = {
    Name = var.az_b_subnet_name
  }
}

# Local Variables
# These local variables store computed values.

locals {
  all_public_subnets = [data.aws_subnet.public_subnets_a.id, data.aws_subnet.public_subnets_b.id]
}

resource "helm_release" "alb_grafana" {
  name      = "${var.alb_grafana_release_name}"
  namespace = kubernetes_namespace.grafana.metadata[0].name
  chart     = var.alb_grafana_chart_path
  version   = var.alb_grafana_chart_version

  set {
    name  = "namespace"
    value = kubernetes_namespace.grafana.metadata[0].name
  }
  
  set {
    name  = "alb.tags"
    value = "Name=${var.alb_grafana_alb_name}"
  }

  set {
    name  = "ingress.host"
    value = "${var.alb_grafana_fqdn}"
  }

  set {
    name  = "ingress.certificateArn"
    value = var.alb_grafana_certificateArn
  }

  set {
    name  = "ingress.subnets"
    value = join("\\,", local.all_public_subnets)
  }

  values = [file(var.alb_grafana_values_file)]

}

# Application Load Balancer (ALB) and DNS Resources
# These resources are related to the Application Load Balancer (ALB) and DNS.

# Retrieve information about the Application Load Balancer (ALB) with the specified tag.
data "aws_lb" "this" {
  tags = {
    Name = "${var.alb_grafana_alb_name}"
  }
}

# Retrieve information about the Route 53 hosted zone with the specified name.
data "aws_route53_zone" "selected" {
  name = var.alb_grafana_domain_name
}

# Define a Route 53 record pointing to the ALB.
resource "aws_route53_record" "alb_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.alb_grafana_record_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.this.dns_name
    zone_id                = data.aws_lb.this.zone_id
    evaluate_target_health = false
  }
}
