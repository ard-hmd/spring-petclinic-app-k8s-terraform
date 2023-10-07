# Output the Zone ID of the Route 53 hosted zone.
output "zone_id" {
  value = data.aws_route53_zone.selected.zone_id
}

# Output the DNS names of the ALBs.
output "alb_dns_names" {
  value = { for ns in var.namespace : ns => data.aws_lb.this[ns].dns_name }
}
















# # Output the Zone ID of the Route 53 hosted zone.
# output "zone_id" {
#   value = data.aws_route53_zone.selected.zone_id
# }

# # Output the DNS name of the ALB.
# output "alb_dns_name" {
#   value = data.aws_lb.this.dns_name
# }
