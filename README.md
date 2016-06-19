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
- `domain_names` - your registered domain name e.g. franck.live
- `logs`        - choose a bucket name for your logs

For more control over what's going on, have a look in `variables.tf`

Usage
-----

```tf
# you don't necessarily need to define a provider
# here if you've already defined it elsewhere
provider "aws" {
  region  = "eu-west-1"
  profile = "circle_ci"
}

module "static_website" {
  source="github.com/KifBV/aws-terraform-static-website"

  # adapt these to your domain names
  # and s3 buckets availability
  domain_names = "franck.live,franck.rocks"
  logs        = "my-static-web-logs"
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

- AWS whitepaper on [building static websites](https://d0.awsstatic.com/whitepapers/Building%20Static%20Websites%20on%20AWS.pdf)
