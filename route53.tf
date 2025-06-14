data "aws_route53_zone" "primary" {
  name         = "sky98.store."
  private_zone = false
}
resource "aws_route53_record" "app_alias" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "hamza"
  type    = "A"

  alias {
    name                   = aws_lb.app_alb.dns_name
    zone_id                = aws_lb.app_alb.zone_id
    evaluate_target_health = true
  }
}
