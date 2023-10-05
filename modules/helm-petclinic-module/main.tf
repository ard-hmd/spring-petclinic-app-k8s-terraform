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
    name  = "ingress.subnets"
    value = join("\\,", local.all_public_subnets)
  }

  values = [file(var.helm_values_file)]
}
