# Retrieve current AWS account identity
data "aws_caller_identity" "current" {}

# Retrieve information about the EKS cluster
data "aws_eks_cluster" "selected" {
  name = var.eks_cluster_name
}

# Define local variables for AWS account ID and OIDC issuer ID
locals {
  aws_account_id = data.aws_caller_identity.current.account_id

  # Split the OIDC issuer URL to extract the issuer ID
  oidc_split     = split("/", data.aws_eks_cluster.selected.identity[0].oidc[0].issuer)
  oidc_id        = local.oidc_split[length(local.oidc_split) - 1]
}

# Create an IAM policy for the ALB controller
resource "aws_iam_policy" "alb_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/iam_policy.json") # Make sure iam_policy.json is in the same directory as your Terraform file
}

# Create an IAM role for the ALB controller
resource "aws_iam_role" "alb_controller" {
  name = var.alb_controller_role_name
  assume_role_policy = templatefile("${path.module}/load-balancer-role-trust-policy.json.tpl", {
    oidc_id        = local.oidc_id,
    aws_account_id = local.aws_account_id
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "alb_controller" {
  policy_arn = aws_iam_policy.alb_controller.arn
  role       = aws_iam_role.alb_controller.name
}

# Create a Kubernetes ServiceAccount for the ALB controller
resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
    }
  }
}

# Deploy the ALB controller using Helm
resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.alb_controller_version

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.alb_controller.metadata[0].name
  }
}
