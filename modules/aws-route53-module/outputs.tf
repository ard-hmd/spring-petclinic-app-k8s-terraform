# Route 53 and ALB Outputs
# These outputs provide information about Route 53 and ALBs.

# Output the Zone ID of the Route 53 hosted zone.
output "zone_id" {
  value = data.aws_route53_zone.selected.zone_id
}

# Output the DNS names of the ALBs.
output "alb_dns_names" {
  value = { for ns in var.namespace : ns => data.aws_lb.this[ns].dns_name }
}
