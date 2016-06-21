Static Website Hosting on AWS with Terraform
===========

Main Resources Provided
------------------

- 1x s3 bucket for each domain name
- 1x s3 bucket for all your websites logs
- 1x route 53 hosted zone for each domain name with:
    - 2x A record aliases to root domain (one pointing to each blue/green cloudfront distribution)
    - 2x A record aliases to www domain (one pointing to each blue/green cloudfront distribution)
    - 1x A record aliases to blue domain (pointing to blue cloudfront distribution)
    - 1x A record aliases to green domain (pointing to green cloudfront distribution)
- 1x delegation set of name servers for all your website
- 2x cloudfront distributions with s3 origin for each domain name:
    - one pointing to production/blue environment
    - one pointing to development/green environment 

Module Input Variables
----------------------

You'll need to initialise at least these when using this module:
- `domain_names` - comma separated list of your registered domain name(s)
- `logs`        - bucket name for your logs

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
  source       = "github.com/KifBV/aws-terraform-static-website"

  # adapt these to your domain names
  # and s3 buckets availability
  domain_names = "franck.live,franck.rocks"
  logs         = "my-static-websites-logs"
}
```

Outputs
-------

 - `NS0` to `NS3` - the nameservers to tell your domain name registrar to use

Upload your content
-------------------

If the static content you need to upload for `example.com` is in the `~/static-website/output/` directory on your computer, and assuming your buckets are in the `eu-west-1` region, run:

`aws s3 sync ~/static-website/output s3://franck.live/ --profile circle_ci --region=eu-west-1`

If you want to test a variation of your website, upload to the dedicated folder in the bucket (`dev` by default):

`aws s3 sync ~/static-website/output/variation s3://example.com/dev/ --profile circle_ci --region=eu-west-1

You can add the `--dryrun` flag to check what would be done...

By default the `green/dev` variation has a weight of 0 and is accessible at `green.example.com`

Links
-----

- AWS whitepaper on [building static websites](https://d0.awsstatic.com/whitepapers/Building%20Static%20Websites%20on%20AWS.pdf)
- my [website](http://franck.live) which I setup with this module
