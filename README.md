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
2. Ensure you have Terraform and `kubectl` installed.
3. Clone this repository.
4. Set up your AWS credentials or ensure your environment can access AWS.
5. Create a `secret.tfvars` file to specify sensitive passwords, like the MySQL root password.
6. Configure your variables in the `terraform.tfvars` file. An example of this file with placeholder values is provided below.

## Configuration Variables

### Main repo:
- `kube_config_path`: Path to the Kubernetes config file.
- `aws_region`: AWS region to deploy resources in.
- `eks_cluster_name`: Name of the EKS cluster.
- `alb_controller_role_name`: Name of the ALB Controller IAM role.
- `alb_controller_version`: Version of the ALB Controller.

### AWS ALB Controller Module:
- `eks_cluster_name`: Name of the EKS cluster. (Example: `example-eks-cluster`)
- `alb_controller_role_name`: Name of the ALB Controller IAM role. (Example: `example-ALB-role`)
- `alb_controller_version`: Version of the ALB Controller. (Example: `1.0.0`)

### Helm PetClinic Module:
- `vpc_name`: Name of the VPC to use. (Example: `example-vpc`)
- `az_a_subnet_name`: Name of the subnet in Availability Zone A. (Example: `example-subnet-a`)
- `az_b_subnet_name`: Name of the subnet in Availability Zone B. (Example: `example-subnet-b`)
- `namespace`: Kubernetes namespace for the Helm release. (Example: `example-namespace`)
- `mysql_root_password`: MySQL root password. (Example: `example-password`)
- `helm_chart_version`: Version of the Helm chart. (Example: `1.0.0`)
- `helm_chart_path`: Path to the Helm chart. (Example: `./example-chart-path`)
- `helm_values_file`: Path to the Helm values file. (Example: `./example-values-path`)
- `helm_release_name`: Name of the Helm release. (Example: `example-release`)
- `repository_prefix`: Prefix for the registry repository. (Example: `example-prefix`)
- `fqdn`: Fully qualified domain name. (Example: `example.com`)
- `certificateArn`: ARN of the ACM certificate. (Example: `arn:aws:acm:example-region:123456789012:certificate/example-id`)

### AWS Route53 Module:
- `alb_name`: Name of the Application Load Balancer (ALB). (Example: `example-alb`)
- `domain_name`: Domain name for Route53. (Example: `example.com.`)
- `record_name`: Name of the DNS record. (Example: `www`)

### Example `terraform.tfvars` file:
```
# General Configuration
kube_config_path = "/path/to/kube/config"
aws_region = "eu-west-1"

# AWS ALB Controller Module Configuration
eks_cluster_name = "example-eks-cluster"
alb_controller_role_name = "example-ALB-role"
alb_controller_version = "1.0.0"

# Helm PetClinic Module Configuration
vpc_name = "example-vpc"
az_a_subnet_name = "example-subnet-a"
az_b_subnet_name = "example-subnet-b"
namespace = "example-namespace"
mysql_root_password = "example-password"
helm_chart_version = "1.0.0"
helm_chart_path = "./example-chart-path"
helm_values_file = "./example-values-path"
helm_release_name = "example-release"
repository_prefix = "example-prefix"
fqdn = "example.com"
certificateArn = "arn:aws:acm:example-region:123456789012:certificate/example-id"

# Database Configuration
vets_dbhost = "example-dbhost.com:3306"
vets_dbname = "example-vetsdb"
vets_dbuser = "example-user"
customers_dbhost = "example-dbhost.com:3306"
customers_dbname = "example-customersdb"
customers_dbuser = "example-user"
visits_dbhost = "example-dbhost.com:3306"
visits_dbname = "example-visitsdb"
visits_dbuser = "example-user"

# AWS Route53 Module Configuration
alb_name = "example-alb"
domain_name = "example.com."
record_name = "www"
```

## Deployment
1. Navigate to the cloned repository directory.
2. Run `terraform init` to initialize the Terraform project.
3. Run `terraform apply -var-file="secret.tfvars"` to deploy the resources. Confirm with `yes` when prompted.

## Destruction
1. To destroy the deployed resources, run `terraform destroy -var-file="secret.tfvars"`.
2. Confirm the destruction by entering `yes` when prompted.
