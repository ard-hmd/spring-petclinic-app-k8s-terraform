variable "namespace" {
  description = "List of Kubernetes namespace names"
  type        = list(string)
}

variable "alb_name" {
  description = "Base name of the Application Load Balancer (ALB)"
}

variable "domain_name" {
  description = "Domain name (without trailing dot)"
}

variable "record_name" {
  description = "Base name of the Route 53 record"
}












# variable "alb_name" {
#   description = "Name of the Application Load Balancer (ALB)"
# }

# variable "domain_name" {
#   description = "Domain name (without trailing dot)"
# }

# variable "record_name" {
#   description = "Name of the Route 53 record"
# }
