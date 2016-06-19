#######################
### Route 53 config ###
#######################

### this will output the NS to configure into your registar
resource "aws_route53_zone" "root_zone" {
  name = "${var.root_domain}"
}

### link s3 root bucket with cloudfront cdn
resource "aws_route53_record" "root" {
  zone_id = "${aws_route53_zone.root_zone.zone_id}"
  name = "${var.root_domain}"
  type = "A"
  alias {
    name = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}
