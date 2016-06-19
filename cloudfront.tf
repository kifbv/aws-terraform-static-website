#########################
### CloudFront config ###
#########################

### origin access identity for cloudfront distribution
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Origin access identity for my static websites"
}

### cloudfront distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${var.root_domain}.s3.amazonaws.com"
    origin_id   = "${var.originID}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  comment             = "${var.root_domain} s3 distribution"
  default_root_object = "${var.index_document}"

  logging_config {
    include_cookies = "${var.log_cookies}"
    bucket          = "${var.logs}.s3.amazonaws.com"
    prefix          = "${var.root_domain}_cdn/"
  }

  aliases = ["${var.root_domain}", "www.${var.root_domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.originID}"
    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "${var.price_class}"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      #locations        = [""]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
