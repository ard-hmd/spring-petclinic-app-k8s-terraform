variable "namespace" {
  description = "Kubernetes namespace name"
}

variable "alb_name" {
  description = "The name of the Application Load Balancer."
}

variable "mysql_root_password" {
  description = "MySQL root password for various databases"
}

variable "vpc_name" {
  description = "Name of the VPC to search for"
}

variable "az_a_subnet_name" {
  description = "Name of the public subnet in Availability Zone A"
}

variable "az_b_subnet_name" {
  description = "Name of the public subnet in Availability Zone B"
}

variable "helm_chart_version" {
  description = "Version of the Helm chart to use for deploying Spring PetClinic"
}

variable "helm_chart_path" {
  description = "Path to the Helm chart for Spring PetClinic"
}

variable "helm_values_file" {
  description = "Path to the Helm values.yaml file"
}

variable "helm_release_name" {
  description = "Name of the Helm release for Spring PetClinic"
}

variable "repository_prefix" {
  description = "Registry repo prefix"
}

variable "fqdn" {
  description = "Fully Qualified Domain Name"
}

variable "certificateArn" {
  description = "ACM certificate ARN"
}

variable "vets_dbhost" {
  description = "The database host for the vets service."
}

variable "vets_dbname" {
  description = "The database name for the vets service."
}

variable "vets_dbuser" {
  description = "The database user for the vets service."
}

variable "customers_dbhost" {
  description = "The database host for the customers service."
}

variable "customers_dbname" {
  description = "The database name for the customers service."
}

variable "customers_dbuser" {
  description = "The database user for the customers service."
}

variable "visits_dbhost" {
  description = "The database host for the visits service."
}

variable "visits_dbname" {
  description = "The database name for the visits service."
}

variable "visits_dbuser" {
  description = "The database user for the visits service."
}
