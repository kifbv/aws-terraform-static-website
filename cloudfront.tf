#########################
### CloudFront config ###
#########################

### origin access identity for cloudfront distribution
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Origin access identity for my static websites"
}

### main cloudfront distribution telling which origin servers to get 
### your files from when users request the files through your website
resource "aws_cloudfront_distribution" "s3_distribution_blue" {
  count = "${length(compact(split(",", var.domain_names)))}"
  origin {
    origin_path = "${var.blue_folder}"
    domain_name = "${element(split(",", var.domain_names), count.index)}.s3.amazonaws.com"
    origin_id   = "${element(split(",", var.domain_names), count.index)}_${var.origin_suffix}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  comment             = "${element(split(",", var.domain_names), count.index)} s3 distribution (production)"
  default_root_object = "${var.index_document}"

  # all logs in one bucket, split domains by prefix
  logging_config {
    include_cookies = "${var.log_cookies}"
    bucket          = "${var.logs}.s3.amazonaws.com"
    prefix          = "${element(split(",", var.domain_names), count.index)}_cdn/"
  }

  # aliases for root, www and production domains
  aliases = ["${element(split(",", var.domain_names), count.index)}",
             "www.${element(split(",", var.domain_names), count.index)}",
             "blue.${element(split(",", var.domain_names), count.index)}"]

  # cache behaviour will be common to all websites
  default_cache_behavior {
    allowed_methods  = ["${split(",", var.cache_allowed_methods)}"]
    cached_methods   = ["${split(",", var.cache_cached_methods)}"]
    target_origin_id = "${element(split(",", var.domain_names), count.index)}_${var.origin_suffix}"
    compress         = true

    forwarded_values {
      query_string = "${var.forward_query_string}"

      cookies {
        forward = "${var.forward_cookies}"
      }
    }

    viewer_protocol_policy = "${var.viewer_protocol_policy}"
    min_ttl                = "${var.min_ttl}"
    default_ttl            = "${var.default_ttl}"
    max_ttl                = "${var.max_ttl}"
  }

  price_class = "${var.price_class}"

  restrictions {
    geo_restriction {
      restriction_type = "${var.geo_restriction_type}"
      #locations        = ["${split(",", var.geo_restriction_locations)}"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

### secondary cloudfront distribution telling which origin servers to get 
### your files from when users request the files through your website
resource "aws_cloudfront_distribution" "s3_distribution_green" {
  count = "${length(compact(split(",", var.domain_names)))}"
  origin {
    origin_path = "${var.green_folder}"
    domain_name = "${element(split(",", var.domain_names), count.index)}.s3.amazonaws.com"
    origin_id   = "${element(split(",", var.domain_names), count.index)}_${var.origin_suffix}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  comment             = "${element(split(",", var.domain_names), count.index)} s3 distribution (development)"
  default_root_object = "${var.index_document}"

  # all logs in one bucket, split domains by prefix
  logging_config {
    include_cookies = "${var.log_cookies}"
    bucket          = "${var.logs}.s3.amazonaws.com"
    prefix          = "${element(split(",", var.domain_names), count.index)}_cdn/"
  }

  # aliases for root, www and development domains
  aliases = ["${element(split(",", var.domain_names), count.index)}",
             "*.${element(split(",", var.domain_names), count.index)}",
             "green.${element(split(",", var.domain_names), count.index)}"]

  # cache behaviour will be common to all websites
  default_cache_behavior {
    allowed_methods  = ["${split(",", var.cache_allowed_methods)}"]
    cached_methods   = ["${split(",", var.cache_cached_methods)}"]
    target_origin_id = "${element(split(",", var.domain_names), count.index)}_${var.origin_suffix}"
    compress         = true

    forwarded_values {
      query_string = "${var.forward_query_string}"

      cookies {
        forward = "${var.forward_cookies}"
      }
    }

    viewer_protocol_policy = "${var.viewer_protocol_policy}"
    min_ttl                = "${var.min_ttl}"
    default_ttl            = "${var.default_ttl}"
    max_ttl                = "${var.max_ttl}"
  }

  price_class = "${var.price_class}"

  restrictions {
    geo_restriction {
      restriction_type = "${var.geo_restriction_type}"
      #locations        = ["${split(",", var.geo_restriction_locations)}"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
