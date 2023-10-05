variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
}

variable "alb_controller_role_name" {
  description = "Name of the IAM role for the ALB controller"
}

variable "alb_controller_version" {
  description = "Version of the AWS ALB controller Helm chart"
}
