Static Website Hosting on AWS with Terraform
===========

Resources Provided
------------------

- s3 bucket for the root domain
- route 53 hosted zone with A records for root and www domain + Name Servers (see Outputs below)
- cloudfront distribution with s3 origin


Module Input Variables
----------------------

You'll need to initialise at least these when using this module:
- `root_domain` - your registered domain name e.g. franck.live
- `logs`        - choose a bucket name for your logs
- `originID`    - choose a bucket name for your cloudfront origin identity

For more control over what's going on, have a look in `variables.tf`

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
  logs = "franck-static-web-logs"
  originID = "franck_live_origin"
}
```

Outputs
-------

 - `NS0` to `NS3` - the nameservers to tell your domain name registrar to use

Upload your content
-------------------

If the static content you need to upload for `mysite.com` is in the `~/static-website/output/` directory on your computer, just run:

`aws s3 sync ~/static-website/output s3://example.com/`

Links
-----

AWS whitepaper on [building static websites](https://d0.awsstatic.com/whitepapers/Building%20Static%20Websites%20on%20AWS.pdf)
