# Provider Configurations
# This section defines the configurations for Terraform providers.

# Kubernetes Provider Configuration
provider "kubernetes" {
  config_path = var.kube_config_path
}

# Helm Provider Configuration
provider "helm" {
  kubernetes {
    config_path = var.kube_config_path
  }
}

# AWS Provider Configuration
provider "aws" {
  region = var.aws_region
}
