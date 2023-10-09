# Common Variables
# These variables are used across multiple modules.

variable "namespace" {
  description = "List of Kubernetes namespace names"
  type        = list(string)
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

variable "repository_prefix" {
  description = "Prefix for the Docker registry repository"
}

variable "mysql_root_password" {
  description = "Root password for MySQL used in various databases"
}

# Inital Config Variables
# These variables are specific to the Spring PetClinic Inital Config.

variable "inital_config_release_name" {
  description = "Name of the Helm release for the Spring PetClinic API Gateway service"
}

variable "inital_config_chart_path" {
  description = "Path to the Helm chart for the Spring PetClinic API Gateway service"
}

variable "inital_config_chart_version" {
  description = "Version of the Helm chart to use for deploying the Spring PetClinic API Gateway service"
}

variable "inital_config_values_file" {
  description = "Path to the Helm values.yaml file for the Spring PetClinic API Gateway service"
}

# API Gateway Service Variables
# These variables are specific to the Spring PetClinic API Gateway service.

variable "api_gateway_service_release_name" {
  description = "Name of the Helm release for the Spring PetClinic API Gateway service"
}

variable "api_gateway_service_chart_path" {
  description = "Path to the Helm chart for the Spring PetClinic API Gateway service"
}

variable "api_gateway_service_chart_version" {
  description = "Version of the Helm chart to use for deploying the Spring PetClinic API Gateway service"
}

variable "api_gateway_service_values_file" {
  description = "Path to the Helm values.yaml file for the Spring PetClinic API Gateway service"
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
}

variable "fqdn" {
  description = "Base Fully Qualified Domain Name"
}

variable "domain_name" {
  description = "Base Fully Qualified Domain Name"
}

variable "record_name" {
  description = "Base Fully Qualified Domain Name"
}

variable "certificateArn" {
  description = "ARN of the ACM certificate"
}

# Customers Service Variables
# These variables are specific to the Spring PetClinic Customers service.

variable "customers_service_release_name" {
  description = "Name of the Helm release for the Spring PetClinic Customers service"
}

variable "customers_service_chart_path" {
  description = "Path to the Helm chart for the Spring PetClinic Customers service"
}

variable "customers_service_chart_version" {
  description = "Version of the Helm chart to use for deploying the Spring PetClinic Customers service"
}

variable "customers_service_values_file" {
  description = "Path to the Helm values.yaml file for the Spring PetClinic Customers service"
}

variable "customers_dbhost" {
  description = "Database host for the Customers service"
}

variable "customers_dbname" {
  description = "Database name for the Customers service"
}

variable "customers_dbuser" {
  description = "Database user for the Customers service"
}

# Visits Service Variables
# These variables are specific to the Spring PetClinic Visits service.

variable "visits_service_release_name" {
  description = "Name of the Helm release for the Spring PetClinic Visits service"
}

variable "visits_service_chart_path" {
  description = "Path to the Helm chart for the Spring PetClinic Visits service"
}

variable "visits_service_chart_version" {
  description = "Version of the Helm chart to use for deploying the Spring PetClinic Visits service"
}

variable "visits_service_values_file" {
  description = "Path to the Helm values.yaml file for the Spring PetClinic Visits service"
}

variable "visits_dbhost" {
  description = "Database host for the Visits service"
}

variable "visits_dbname" {
  description = "Database name for the Visits service"
}

variable "visits_dbuser" {
  description = "Database user for the Visits service"
}

# Vets Service Variables
# These variables are specific to the Spring PetClinic Vets service.

variable "vets_service_release_name" {
  description = "Name of the Helm release for the Spring PetClinic Vets service"
}

variable "vets_service_chart_path" {
  description = "Path to the Helm chart for the Spring PetClinic Vets service"
}

variable "vets_service_chart_version" {
  description = "Version of the Helm chart to use for deploying the Spring PetClinic Vets service"
}

variable "vets_service_values_file" {
  description = "Path to the Helm values.yaml file for the Spring PetClinic Vets service"
}

variable "vets_dbhost" {
  description = "Database host for the Vets service"
}

variable "vets_dbname" {
  description = "Database name for the Vets service"
}

variable "vets_dbuser" {
  description = "Database user for the Vets service"
}
