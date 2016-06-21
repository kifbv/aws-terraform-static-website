#######################
### Route 53 config ###
#######################

### use a single set of name servers for all our static websites records
resource "aws_route53_delegation_set" "main" {
    reference_name = "Static Websites"
}

### one hosted zone for each domain
resource "aws_route53_zone" "root_zone" {
  count             = "${length(compact(split(",", var.domain_names)))}"
  name              = "${element(split(",", var.domain_names), count.index)}"
  delegation_set_id = "${aws_route53_delegation_set.main.id}"
  tags = {
    Domain = "${element(split(",", var.domain_names), count.index)}"
  }
}

### this is the production record for root domain
resource "aws_route53_record" "production" {
  count          = "${length(compact(split(",", var.domain_names)))}"
  name           = "${element(split(",", var.domain_names), count.index)}"
  zone_id        = "${element(aws_route53_zone.root_zone.*.zone_id, count.index)}"
  type           = "A"
  weight         = "${var.blue_weight}"
  set_identifier = "${element(split(",", var.domain_names), count.index)}-blue"
  alias {
    name                   = "${element(aws_cloudfront_distribution.s3_distribution_blue.*.domain_name, count.index)}"
    zone_id                = "${element(aws_cloudfront_distribution.s3_distribution_blue.*.hosted_zone_id, count.index)}"
    evaluate_target_health = false
  }
}

### this is the production record for www domain
resource "aws_route53_record" "production" {
  count          = "${length(compact(split(",", var.domain_names)))}"
  name           = "www.${element(split(",", var.domain_names), count.index)}"
  zone_id        = "${element(aws_route53_zone.root_zone.*.zone_id, count.index)}"
  type           = "A"
  weight         = "${var.blue_weight}"
  set_identifier = "${element(split(",", var.domain_names), count.index)}-blue"
  alias {
    name                   = "${element(aws_cloudfront_distribution.s3_distribution_blue.*.domain_name, count.index)}"
    zone_id                = "${element(aws_cloudfront_distribution.s3_distribution_blue.*.hosted_zone_id, count.index)}"
    evaluate_target_health = false
  }
}

### this is the production record for blue domain
resource "aws_route53_record" "production" {
  count          = "${length(compact(split(",", var.domain_names)))}"
  name           = "blue.${element(split(",", var.domain_names), count.index)}"
  zone_id        = "${element(aws_route53_zone.root_zone.*.zone_id, count.index)}"
  type           = "A"
  weight         = "${var.blue_weight}"
  set_identifier = "${element(split(",", var.domain_names), count.index)}-blue"
  alias {
    name                   = "${element(aws_cloudfront_distribution.s3_distribution_blue.*.domain_name, count.index)}"
    zone_id                = "${element(aws_cloudfront_distribution.s3_distribution_blue.*.hosted_zone_id, count.index)}"
    evaluate_target_health = false
  }
}

### this is the development record for root domain
### weighted 0 by default (see variables.tf)
resource "aws_route53_record" "development" {
  count          = "${length(compact(split(",", var.domain_names)))}"
  name           = "${element(split(",", var.domain_names), count.index)}"
  zone_id        = "${element(aws_route53_zone.root_zone.*.zone_id, count.index)}"
  type           = "A"
  weight         = "${var.green_weight}"
  set_identifier = "${element(split(",", var.domain_names), count.index)}-green"
  alias {
    name                   = "${element(aws_cloudfront_distribution.s3_distribution_green.*.domain_name, count.index)}"
    zone_id                = "${element(aws_cloudfront_distribution.s3_distribution_green.*.hosted_zone_id, count.index)}"
    evaluate_target_health = false
  }
}

### this is the development record for www domain
### weighted 0 by default (see variables.tf)
resource "aws_route53_record" "development" {
  count          = "${length(compact(split(",", var.domain_names)))}"
  name           = "www.${element(split(",", var.domain_names), count.index)}"
  zone_id        = "${element(aws_route53_zone.root_zone.*.zone_id, count.index)}"
  type           = "A"
  weight         = "${var.green_weight}"
  set_identifier = "${element(split(",", var.domain_names), count.index)}-green"
  alias {
    name                   = "${element(aws_cloudfront_distribution.s3_distribution_green.*.domain_name, count.index)}"
    zone_id                = "${element(aws_cloudfront_distribution.s3_distribution_green.*.hosted_zone_id, count.index)}"
    evaluate_target_health = false
  }
}

### this is the development record for green domain
### weighted 0 by default (see variables.tf)
resource "aws_route53_record" "development" {
  count          = "${length(compact(split(",", var.domain_names)))}"
  name           = "green.${element(split(",", var.domain_names), count.index)}"
  zone_id        = "${element(aws_route53_zone.root_zone.*.zone_id, count.index)}"
  type           = "A"
  weight         = "${var.green_weight}"
  set_identifier = "${element(split(",", var.domain_names), count.index)}-green"
  alias {
    name                   = "${element(aws_cloudfront_distribution.s3_distribution_green.*.domain_name, count.index)}"
    zone_id                = "${element(aws_cloudfront_distribution.s3_distribution_green.*.hosted_zone_id, count.index)}"
    evaluate_target_health = false
  }
}
