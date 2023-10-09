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

# Resources
# These resources define and create infrastructure components.

# Create Kubernetes namespaces
resource "kubernetes_namespace" "ns" {
  for_each = toset(var.namespace)
  metadata {
    name = each.value
  }
}

# Create Kubernetes secrets for MySQL root passwords
resource "kubernetes_secret" "customers_db_mysql" {
  for_each = toset(var.namespace)
  metadata {
    name      = "customers-db-mysql"
    namespace = each.value
  }

  data = {
    "mysql-root-password" = var.mysql_root_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "vets_db_mysql" {
  for_each = toset(var.namespace)
  metadata {
    name      = "vets-db-mysql"
    namespace = each.value
  }

  data = {
    "mysql-root-password" = var.mysql_root_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "visits_db_mysql" {
  for_each = toset(var.namespace)
  metadata {
    name      = "visits-db-mysql"
    namespace = each.value
  }

  data = {
    "mysql-root-password" = var.mysql_root_password
  }

  type = "Opaque"
}

# Deploy Helm releases
resource "helm_release" "inital_config" {
  for_each = toset(var.namespace)
  name      = "${var.inital_config_release_name}-${each.value}"
  namespace = each.value
  chart     = var.inital_config_chart_path
  version   = var.inital_config_chart_version

  set {
    name  = "namespace"
    value = each.value
  }

  values = [file(var.inital_config_values_file)]
  
  depends_on = [kubernetes_namespace.ns]
}


# Deploy Helm releases
resource "helm_release" "api_gateway_service" {
  for_each = toset(var.namespace)
  name      = "${var.api_gateway_service_release_name}-${each.value}"
  namespace = each.value
  chart     = var.api_gateway_service_chart_path
  version   = var.api_gateway_service_chart_version

  set {
    name  = "namespace"
    value = each.value
  }
  
  set {
    name  = "alb.tags"
    value = "Name=${var.alb_name}"
  }

  set {
    name  = "repository_prefix"
    value = var.repository_prefix
  }

  set {
    name  = "ingress.host"
    value = "${var.fqdn}"
  }

  set {
    name  = "ingress.certificateArn"
    value = var.certificateArn
  }

  set {
    name  = "ingress.subnets"
    value = join("\\,", local.all_public_subnets)
  }

  values = [file(var.api_gateway_service_values_file)]

  depends_on = [helm_release.inital_config]
}

resource "helm_release" "customers_service" {
  for_each = toset(var.namespace)
  name      = "${var.customers_service_release_name}-${each.value}"
  namespace = each.value
  chart     = var.customers_service_chart_path
  version   = var.customers_service_chart_version

  set {
    name  = "namespace"
    value = each.value
  }
  
  set {
    name  = "repository_prefix"
    value = var.repository_prefix
  }

  set {
    name  = "customers.dbhost"
    value = var.customers_dbhost
  }

  set {
    name  = "customers.dbname"
    value = var.customers_dbname
  }

  set {
    name  = "customers.dbuser"
    value = var.customers_dbuser
  }

  values = [file(var.customers_service_values_file)]

  depends_on = [helm_release.inital_config]
}

resource "helm_release" "vets_service" {
  for_each = toset(var.namespace)
  name      = "${var.vets_service_release_name}-${each.value}"
  namespace = each.value
  chart     = var.vets_service_chart_path
  version   = var.vets_service_chart_version

  set {
    name  = "namespace"
    value = each.value
  }

  set {
    name  = "repository_prefix"
    value = var.repository_prefix
  }

  set {
    name  = "vets.dbhost"
    value = var.vets_dbhost
  }

  set {
    name  = "vets.dbname"
    value = var.vets_dbname
  }

  set {
    name  = "vets.dbuser"
    value = var.vets_dbuser
  }

  values = [file(var.vets_service_values_file)]

  depends_on = [helm_release.inital_config]
}

resource "helm_release" "visits_service" {
  for_each = toset(var.namespace)
  name      = "${var.visits_service_release_name}-${each.value}"
  namespace = each.value
  chart     = var.visits_service_chart_path
  version   = var.visits_service_chart_version

  set {
    name  = "namespace"
    value = each.value
  }

  set {
    name  = "repository_prefix"
    value = var.repository_prefix
  }

  set {
    name  = "visits.dbhost"
    value = var.visits_dbhost
  }

  set {
    name  = "visits.dbname"
    value = var.visits_dbname
  }

  set {
    name  = "visits.dbuser"
    value = var.visits_dbuser
  }

  values = [file(var.visits_service_values_file)]

  depends_on = [helm_release.inital_config]
}