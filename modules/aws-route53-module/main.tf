data "aws_lb" "this" {
  tags = {
    Name = "mon-alb-petclinic"
  }
}

data "aws_route53_zone" "selected" {
  name = "ahermand.fr." # Remplacez par le nom de votre domaine
}

output "zone_id" {
  value = data.aws_route53_zone.selected.zone_id
}

resource "aws_route53_record" "alb_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www.ahermand.fr."
  type    = "A"

  alias {
    name                   = data.aws_lb.this.dns_name
    zone_id                = data.aws_lb.this.zone_id
    evaluate_target_health = false
  }
}