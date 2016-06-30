# the following are initialised in your module declaration
variable "domain_names" { }
variable "logs" { }

# you can keep these ones
variable "index_document" { default = "index.html" }
variable "error_document" { default = "404.html" }

# sub-domain names for your test environments
variable "blue_sub_domain" { default = "blue" }
variable "green_sub_domain" { default = "green" }

### cloudfront ###

variable "blue_folder" { default = "" }
variable "green_folder" { default = "/dev" }
variable "log_cookies" { default = "false" }
variable "origin_suffix" { default = "origin" }
variable "forward_query_string" { default = "false" }
variable "forward_cookies" { default = "none" }
variable "viewer_protocol_policy" { default = "allow-all" }
variable "min_ttl" { default = "0" }
variable "default_ttl" { default = "3600" }
variable "max_ttl" { default = "86400" }
variable "cache_allowed_methods" { default = "DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT" }
variable "cache_cached_methods" { default = "GET,HEAD" }

# can't find a way to make all types work
variable "geo_restriction_type" { default = "none" }
#variable "geo_restriction_locations" { default = "" }
#variable "geo_restriction_locations" { default = "CN,FR,US" }

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
