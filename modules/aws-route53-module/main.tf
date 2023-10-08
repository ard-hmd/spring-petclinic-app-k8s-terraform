# Application Load Balancer (ALB) and DNS Resources
# These resources are related to the Application Load Balancer (ALB) and DNS.

# Retrieve information about the Application Load Balancer (ALB) with the specified tag.
data "aws_lb" "this" {
  for_each = toset(var.namespace)
  tags = {
    Name = "${var.alb_name}"
  }
}

# Retrieve information about the Route 53 hosted zone with the specified name.
data "aws_route53_zone" "selected" {
  name = var.domain_name
}

# Define a Route 53 record pointing to the ALB.
resource "aws_route53_record" "alb_record" {
  for_each = toset(var.namespace)
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.record_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.this[each.value].dns_name
    zone_id                = data.aws_lb.this[each.value].zone_id
    evaluate_target_health = false
  }
}
