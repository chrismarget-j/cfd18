data "aws_route53_zone" "o" {
  name = "t3aco.fragmentationneeded.net"
}

resource "aws_route53_record" "o" {
  name    = local.dns
  type    = "A"
  ttl     = 30
  zone_id = data.aws_route53_zone.o.zone_id
  records = [aws_eip.o.public_ip]
}