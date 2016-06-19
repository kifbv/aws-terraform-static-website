##################
### S3 config  ###
##################

### main bucket where the static website goes
resource "aws_s3_bucket" "root_bucket" {
    count  = "${length(compact(split(",", var.domain_names)))}"
    bucket = "${element(split(",", var.domain_names), count.index)}"
    policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement": [{
    "Sid": "Allow Public Access to All Objects",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${element(split(",", var.domain_names), count.index)}/*"
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
        Name = "${element(split(",", var.domain_names), count.index)} s3 bucket"
    }

   logging {
       target_bucket = "${aws_s3_bucket.logs_bucket.id}"
       target_prefix = "${element(split(",", var.domain_names), count.index)}_s3/"
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
