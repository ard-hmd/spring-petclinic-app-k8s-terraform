variable "namespace" {
  description = "Kubernetes namespace name"
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
