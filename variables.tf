##############
### inputs ###
##############

# the following are initialised in your module declaration
variable "domain_names" { }
variable "logs" { }

# you can keep these ones
variable "index_document" { default = "index.html" }
variable "error_document" { default = "error.html" }

### cloudfront ###

variable "blue_folder" { default = "/" }
variable "green_folder" { default = "/dev/" }
variable "log_cookies" { default = "false" }
variable "origin_suffix" { default = "origin" }
variable "forward_query_string" { default = "false" }
variable "forward_cookies" { default = "none" }
variable "viewer_protocol_policy" { default = "allow-all" }
variable "min_ttl" { default = "0" }
variable "default_ttl" { default = "3600" }
variable "max_ttl" { default = "86400" }
variable "geo_restriction_type" { default = "none" }
variable "geo_restriction_locations" { default = [""] }
variable "cache_allowed_methods" { default = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"] }
variable "cache_cached_methods" { default = ["GET", "HEAD"] }

# price class determines how widely your s3 content is copied to edge locations
# see http://aws.amazon.com/cloudfront/pricing/ for exact locations
# class 100 = EU + USA
# class 200 = EU + USA + some more
# class All = all edge locations
variable "price_class" { default = "PriceClass_All" }

### route53 ###

variable "blue_weight" { default = "100" }
variable "green_weight" { default = "0" }

### s3 ###

###############
### outputs ###
###############

# you will need to tell these to your domain name registrar
output "NS0" { value ="${aws_route53_delegation_set.main.name_servers.0}" }
output "NS1" { value ="${aws_route53_delegation_set.main.name_servers.1}" }
output "NS2" { value ="${aws_route53_delegation_set.main.name_servers.2}" }
output "NS3" { value ="${aws_route53_delegation_set.main.name_servers.3}" }
