# Spring PetClinic Application Deployment with Kubernetes and Terraform

## Introduction
This repository contains the Terraform configuration to deploy the Spring PetClinic application on a Kubernetes cluster in AWS. It utilizes several modules to handle different parts of the deployment, from setting up AWS infrastructure to deploying the application in the cluster.

## Key Features
- Deployment of the AWS Application Load Balancer (ALB) Controller for the EKS cluster.
- Configuration of AWS infrastructure, including IAM roles and Route53 records.
- Deployment of the Spring PetClinic application via Helm.
- Management of database secrets and configurations in Kubernetes.

## Initial Setup
1. Ensure you have an operational EKS cluster with at least 2 Availability Zones.
2. Ensure you have an AWS Certificate Manager (ACM) certificate available for use.
3. Ensure you possess a domain name and have a corresponding Route53 hosted zone set up in AWS.
4. Ensure you have Terraform and `kubectl` installed.
5. Clone this repository.
6. Set up your AWS credentials or ensure your environment can access AWS.
7. Create a `secret.tfvars` file to specify sensitive passwords, like the MySQL root password.
8. Configure your variables in the `terraform.tfvars` file.

## Configuration Variables

### Main repo:
- `kube_config_path`: Path to the Kubernetes config file.
- `aws_region`: AWS region to deploy resources in.
- `eks_cluster_name`: Name of the EKS cluster.
- `alb_controller_role_name`: Name of the ALB Controller IAM role.
- `alb_controller_version`: Version of the ALB Controller.

### AWS ALB Controller Module:
- `eks_cluster_name`: Name of the EKS cluster.
- `alb_controller_role_name`: Name of the ALB Controller IAM role.
- `alb_controller_version`: Version of the ALB Controller.

### Helm PetClinic Module:
- `vpc_name`: Name of the VPC to use.
- `az_a_subnet_name`: Name of the subnet in Availability Zone A.
- `az_b_subnet_name`: Name of the subnet in Availability Zone B.
- `namespace`: Kubernetes namespace for the Helm release.
- `repository_prefix`: Prefix for the registry repository.
- `cleaned_domain_name`: Cleaned domain name.
- `api_gateway_service_release_name`: Name of the Helm release for the API Gateway service.
- `api_gateway_service_chart_path`: Path to the Helm chart for the API Gateway service.
- `api_gateway_service_chart_version`: Version of the Helm chart for the API Gateway service.
- `api_gateway_service_values_file`: Path to the values file for the API Gateway service.
- `alb_name`: Name of the Application Load Balancer.
- `certificateArn`: ARN of the ACM certificate.
- `customers_service_release_name`: Name of the Helm release for the Customers service.
- `customers_service_chart_path`: Path to the Helm chart for the Customers service.
- `customers_service_chart_version`: Version of the Helm chart for the Customers service.
- `customers_service_values_file`: Path to the values file for the Customers service.
- `customers_dbhost`: Database host for the Customers service.
- `customers_dbname`: Database name for the Customers service.
- `customers_dbuser`: Database user for the Customers service.
- `visits_service_release_name`: Name of the Helm release for the Visits service.
- `visits_service_chart_path`: Path to the Helm chart for the Visits service.
- `visits_service_chart_version`: Version of the Helm chart for the Visits service.
- `visits_service_values_file`: Path to the values file for the Visits service.
- `visits_dbhost`: Database host for the Visits service.
- `visits_dbname`: Database name for the Visits service.
- `visits_dbuser`: Database user for the Visits service.
- `vets_service_release_name`: Name of the Helm release for the Vets service.
- `vets_service_chart_path`: Path to the Helm chart for the Vets service.
- `vets_service_chart_version`: Version of the Helm chart for the Vets service.
- `vets_service_values_file`: Path to the values file for the Vets service.
- `vets_dbhost`: Database host for the Vets service.
- `vets_dbname`: Database name for the Vets service.
- `vets_dbuser`: Database user for the Vets service.

### AWS Route53 Module:
- `alb_name`: Name of the Application Load Balancer (ALB).
- `domain_name`: Domain name for Route53.
- `record_name`: Name of the DNS record.

### Example `terraform.tfvars` file:
```
# Main Terraform Configuration Variables
kube_config_path         = "/path/to/kube/config"
aws_region               = "eu-west-1"
eks_cluster_name         = "my-eks-cluster"
alb_controller_role_name = "my-ALB-role"
alb_controller_version   = "1.0.0"

# Helm PetClinic Module Variables
vpc_name                 = "my-vpc"
az_a_subnet_name         = "my-subnet-a"
az_b_subnet_name         = "my-subnet-b"
namespace                = ["my-namespace"]
repository_prefix        = "my-prefix"
cleaned_domain_name      = "example.com"
api_gateway_service_release_name  = "api-gateway-release"
api_gateway_service_chart_path    = "/path/to/api-gateway-chart"
api_gateway_service_chart_version = "1.0.0"
api_gateway_service_values_file   = "/path/to/api-gateway-values"
alb_name                          = "my-alb"
certificateArn                    = "arn:aws:acm:eu-west-1:123456789012:certificate/abcd-1234"
customers_service_release_name    = "customers-release"
customers_service_chart_path      = "/path/to/customers-chart"
customers_service_chart_version   = "1.0.0"
customers_service_values_file     = "/path/to/customers-values"
customers_dbhost                  = "dbhost.com:3306"
customers_dbname                  = "customersdb"
customers_dbuser                  = "user"
visits_service_release_name       = "visits-release"
visits_service_chart_path         = "/path/to/visits-chart"
visits_service_chart_version      = "1.0.0"
visits_service_values_file        = "/path/to/visits-values"
visits_dbhost                     = "dbhost.com:3306"
visits_dbname                     = "visitsdb"
visits_dbuser                     = "user"
vets_service_release_name         = "vets-release"
vets_service_chart_path           = "/path/to/vets-chart"
vets_service_chart_version        = "1.0.0"
vets_service_values_file          = "/path/to/vets-values"
vets_dbhost                       = "dbhost.com:3306"
vets_dbname                       = "vetsdb"
vets_dbuser                       = "user"

# AWS Route53 Module Variables
alb_name      = "my-alb"
domain_name   = "example.com."
record_name   = "www"
```

## Deployment
1. Navigate to the cloned repository directory.
2. Run `terraform init` to initialize the Terraform project.
3. Run `terraform apply -var-file="secret.tfvars"` to deploy the resources. Confirm with `yes` when prompted.

## Destruction
1. To destroy the deployed resources, run `terraform destroy -var-file="secret.tfvars"`.
2. Confirm the destruction by entering `yes` when prompted.
