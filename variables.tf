# Kubernetes Configuration
variable "kube_config_path" {
  description = "The path to the Kubernetes config file."
  type        = string
}

# AWS Configuration
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

# AWS EKS Configuration
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

# VPC Configuration
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

# Namespace Configuration
variable "namespace" {
  description = "The namespace for the Helm release."
  type        = list(string)
}

# MySQL Configuration
variable "mysql_root_password" {
  description = "The MySQL root password."
  type        = string
  sensitive   = true
}

variable "repository_prefix" {
  description = "Registry repo prefix"
  type        = string
}

# DNS and Route53 Configuration
variable "domain_name" {
  description = "The domain name for Route53."
  type        = string
}

variable "record_name" {
  description = "The DNS record name."
  type        = string
}

variable "cleaned_domain_name" {
  description = "A cleaned version of the domain name without a trailing period."
  type        = string
}

# Application Load Balancer Configuration
variable "alb_name" {
  description = "Name of the Application Load Balancer."
  type        = string
}

variable "certificateArn" {
  description = "ARN of the ACM certificate."
  type        = string
}

# Spring PetClinic Inital Config
variable "inital_config_release_name" {
  description = "Name of the Helm release for the Spring PetClinic Initial Config."
  type        = string
}

variable "inital_config_chart_path" {
  description = "Path to the Helm chart for the Spring PetClinic Initial Config."
  type        = string
}

variable "inital_config_chart_version" {
  description = "Version of the Helm chart to use for deploying the Spring PetClinic Initial Config."
  type        = string
}

variable "inital_config_values_file" {
  description = "Path to the Helm values.yaml file for the Spring PetClinic Initial Config."
  type        = string
}

# Spring PetClinic API Gateway Service Configuration
variable "api_gateway_service_release_name" {
  description = "Name of the Helm release for the Spring PetClinic API Gateway service."
  type        = string
}

variable "api_gateway_service_chart_path" {
  description = "Path to the Helm chart for the Spring PetClinic API Gateway service."
  type        = string
}

variable "api_gateway_service_chart_version" {
  description = "Version of the Helm chart to use for deploying the Spring PetClinic API Gateway service."
  type        = string
}

variable "api_gateway_service_values_file" {
  description = "Path to the Helm values.yaml file for the Spring PetClinic API Gateway service."
  type        = string
}

# Spring PetClinic Customers Service Configuration
variable "customers_service_release_name" {
  description = "Name of the Helm release for the Spring PetClinic Customers service."
  type        = string
}

variable "customers_service_chart_path" {
  description = "Path to the Helm chart for the Spring PetClinic Customers service."
  type        = string
}

variable "customers_service_chart_version" {
  description = "Version of the Helm chart to use for deploying the Spring PetClinic Customers service."
  type        = string
}

variable "customers_service_values_file" {
  description = "Path to the Helm values.yaml file for the Spring PetClinic Customers service."
  type        = string
}

variable "customers_dbhost" {
  description = "Database host for the Customers service."
  type        = string
}

variable "customers_dbname" {
  description = "Database name for the Customers service."
  type        = string
}

variable "customers_dbuser" {
  description = "Database user for the Customers service."
  type        = string
}

# Spring PetClinic Visits Service Configuration
variable "visits_service_release_name" {
  description = "Name of the Helm release for the Spring PetClinic Visits service."
  type        = string
}

variable "visits_service_chart_path" {
  description = "Path to the Helm chart for the Spring PetClinic Visits service."
  type        = string
}

variable "visits_service_chart_version" {
  description = "Version of the Helm chart to use for deploying the Spring PetClinic Visits service."
  type        = string
}

variable "visits_service_values_file" {
  description = "Path to the Helm values.yaml file for the Spring PetClinic Visits service."
  type        = string
}

variable "visits_dbhost" {
  description = "Database host for the Visits service."
  type        = string
}

variable "visits_dbname" {
  description = "Database name for the Visits service."
  type        = string
}

variable "visits_dbuser" {
  description = "Database user for the Visits service."
  type        = string
}

# Spring PetClinic Vets Service Configuration
variable "vets_service_release_name" {
  description = "Name of the Helm release for the Spring PetClinic Vets service."
  type        = string
}

variable "vets_service_chart_path" {
  description = "Path to the Helm chart for the Spring PetClinic Vets service."
  type        = string
}

variable "vets_service_chart_version" {
  description = "Version of the Helm chart to use for deploying the Spring PetClinic Vets service."
  type        = string
}

variable "vets_service_values_file" {
  description = "Path to the Helm values.yaml file for the Spring PetClinic Vets service."
  type        = string
}

variable "vets_dbhost" {
  description = "Database host for the Vets service."
  type        = string
}

variable "vets_dbname" {
  description = "Database name for the Vets service."
  type        = string
}

variable "vets_dbuser" {
  description = "Database user for the Vets service."
  type        = string
}
