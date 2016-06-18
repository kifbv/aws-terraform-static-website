##################
### S3 config  ###
##################

### main bucket where the static website goes
resource "aws_s3_bucket" "root_bucket" {
    bucket = "${var.root_domain}"
    policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement": [{
    "Sid": "Allow Public Access to All Objects",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${var.root_domain}/*"
  }
 ]
}
EOF

    website {
        index_document = "${var.index_document}"
        error_document = "${var.error_document}"
    }

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["GET"]
        allowed_origins = ["*"]
        expose_headers = ["ETag"]
        max_age_seconds = 3000
    }

    tags {
        Name = "${var.root_domain} s3 bucket"
    }

   logging {
       target_bucket = "${aws_s3_bucket.logs_bucket.id}"
       target_prefix = "${var.root_domain}_s3/"
   }
}

### s3 bucket for www redirects to root s3 bucket
resource "aws_s3_bucket" "www_bucket" {
    bucket = "${var.www_domain}"
    acl = "public-read"

    website {
        redirect_all_requests_to = "${var.root_domain}"
    }

    tags {
        Name = "${var.www_domain} s3 bucket"
    }
}

### s3 bucket for all static websites + cdn logs
resource "aws_s3_bucket" "logs_bucket" {
    bucket = "${var.logs}"
    acl = "log-delivery-write"
    
    tags {
        Name = "Static Websites Logs"
    }
}
