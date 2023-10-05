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

# Define local variable to store all public subnet IDs
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
  name      = var.helm_release_name
  namespace = var.namespace
  chart     = var.helm_chart_path
  version   = var.helm_chart_version

  set {
    name  = "namespace"
    value = var.namespace
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
    value = var.fqdn
  }

  set {
    name  = "ingress.certificateArn"
    value = var.certificateArn
  }

  set {
    name  = "ingress.subnets"
    value = join("\\,", local.all_public_subnets)
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
  values = [file(var.helm_values_file)]
}
