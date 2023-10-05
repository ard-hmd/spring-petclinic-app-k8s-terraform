# Variables for the main Terraform configuration

# Path to Kubernetes config file
variable "kube_config_path" {
  description = "The path to the Kubernetes config file."
  type        = string
}

# AWS region
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

# Variables specific to the aws-alb-controller-module
variable "eks_cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "alb_controller_role_name" {
  description = "The name of the ALB Controller IAM role."
  type        = string
}

variable "alb_controller_version" {
  description = "The version of the ALB Controller."
  type        = string
}

# Variables specific to the helm-petclinic-module
variable "vpc_name" {
  description = "The name of the VPC to use."
  type        = string
}

variable "az_a_subnet_name" {
  description = "The name of the subnet in Availability Zone A."
  type        = string
}

variable "az_b_subnet_name" {
  description = "The name of the subnet in Availability Zone B."
  type        = string
}

variable "namespace" {
  description = "The namespace for the Helm release."
  type        = string
}

variable "mysql_root_password" {
  description = "The MySQL root password."
  type        = string
  sensitive   = true
}

variable "helm_chart_version" {
  description = "The version of the Helm chart to use."
  type        = string
}

variable "helm_chart_path" {
  description = "The path to the Helm chart."
  type        = string
}

variable "helm_values_file" {
  description = "The path to the Helm values file."
  type        = string
}

variable "helm_release_name" {
  description = "The name of the Helm release."
  type        = string
}

# Additional variables for database configuration
variable "vets_dbhost" {
  description = "The database host for the vets service."
  type        = string
}

variable "vets_dbname" {
  description = "The database name for the vets service."
  type        = string
}

variable "vets_dbuser" {
  description = "The database user for the vets service."
  type        = string
}

variable "customers_dbhost" {
  description = "The database host for the customers service."
  type        = string
}

variable "customers_dbname" {
  description = "The database name for the customers service."
  type        = string
}

variable "customers_dbuser" {
  description = "The database user for the customers service."
  type        = string
}

variable "visits_dbhost" {
  description = "The database host for the visits service."
  type        = string
}

variable "visits_dbname" {
  description = "The database name for the visits service."
  type        = string
}

variable "visits_dbuser" {
  description = "The database user for the visits service."
  type        = string
}

variable "repository_prefix" {
  description = "Registry repo prefix"
  type        = string
}

variable "fqdn" {
  description = "Fully Qualified Domain Name"
  type        = string
}

variable "certificateArn" {
  description = "ACM certificate ARN"
  type        = string
}

# Variables specific to the aws-route53-module
variable "alb_name" {
  description = "The name of the Application Load Balancer."
  type        = string
}

variable "domain_name" {
  description = "The domain name for Route53."
  type        = string
}

variable "record_name" {
  description = "The DNS record name."
  type        = string
}

