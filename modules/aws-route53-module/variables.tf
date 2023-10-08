# Common Variables
# These variables are used across multiple modules.

variable "namespace" {
  description = "List of Kubernetes namespace names"
  type        = list(string)
}

# Application Load Balancer (ALB) Variables
# These variables are related to the Application Load Balancer.

variable "alb_name" {
  description = "Base name of the Application Load Balancer (ALB)"
}

# DNS Variables
# These variables are related to DNS and Route 53.

variable "domain_name" {
  description = "Domain name (without trailing dot)"
}

variable "record_name" {
  description = "Base name of the Route 53 record"
}
