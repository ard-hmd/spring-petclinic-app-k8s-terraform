# EKS Cluster and ALB Controller Variables
# These variables are related to the EKS cluster and the AWS ALB controller.

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
}

variable "alb_controller_role_name" {
  description = "Name of the IAM role for the ALB controller"
}

variable "alb_controller_version" {
  description = "Version of the AWS ALB controller Helm chart"
}
