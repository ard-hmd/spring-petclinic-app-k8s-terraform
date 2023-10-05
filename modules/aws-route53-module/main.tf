# Retrieve information about the Application Load Balancer (ALB) with the specified tag.
data "aws_lb" "this" {
  tags = {
    Name = var.alb_name
  }
}

# Retrieve information about the Route 53 hosted zone with the specified name.
data "aws_route53_zone" "selected" {
  name = var.domain_name
}

# Define a Route 53 record pointing to the ALB.
resource "aws_route53_record" "alb_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = data.aws_lb.this.dns_name
    zone_id                = data.aws_lb.this.zone_id
    evaluate_target_health = false
  }
}
