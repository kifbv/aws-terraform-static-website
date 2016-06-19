##############
### inputs ###
##############

# the following are initialised in you module declaration
variable "root_domain" { }
variable "logs" { }
variable "originID" { }

# you can keep these ones
variable "index_document" { default = "index.html" }
variable "error_document" { default = "error.html" }

# other variables are listed below by resource

### cloudfront

variable "log_cookies" { default = "false" }

# price class determines how widely your s3 content is copied to edge locations
# see http://aws.amazon.com/cloudfront/pricing/ for exact locations
# class 100 = EU + USA
variable "price_class" { default = "PriceClass_100" }

###############
### outputs ###
###############

# you will need to tell these to your domain name registrar
output "NS0" { value ="${aws_route53_zone.root_zone.name_servers.0}" }
output "NS1" { value ="${aws_route53_zone.root_zone.name_servers.1}" }
output "NS2" { value ="${aws_route53_zone.root_zone.name_servers.2}" }
output "NS3" { value ="${aws_route53_zone.root_zone.name_servers.3}" }
