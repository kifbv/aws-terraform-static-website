Static Website Hosting on AWS with Terraform
===========

Resources Provided
------------------

- two s3 buckets, one for the root domain, one for the www domain
- route 53 hosted zone with A records for root and www domain + Name Servers (see Outputs below)
- cloudfront distribution with s3 origin


Module Input Variables
----------------------

- `root_domain`
- `www_domain`
- `logs`
- `originID`

Usage
-----

```tf
module "static_website" {
  source="github.com/KifBV/aws-static-website"

  # you don't need to specify the region and profile
  # if you already initialise them elsewhere
  aws_region = "eu-west-1"
  aws_profile = "circle_ci"

  # adapt these to your domain name
  # and s3 buckets availability
  root_domain = "franck.live"
  www_domain = "www.franck.live"
  logs = "franck-static-web-logs"
  originID = "franck_live_origin"
}
```

Outputs
-------

 - `NS0` to `NS3` - the nameservers to configure in your domain name registrar

Upload your content
----------------------

If the static content you need to upload for `example.com` is in the `~/static-website/output/` directory, just run:
  `aws s3 sync ~/static-website/output s3://example.com/`
