output "NS0" {
  value = "${aws_route53_delegation_set.main.name_servers.0}"
}
output "NS1" {
  value = "${aws_route53_delegation_set.main.name_servers.1}"
}
output "NS2" {
  value = "${aws_route53_delegation_set.main.name_servers.2}"
}
output "NS3" {
  value = "${aws_route53_delegation_set.main.name_servers.3}"
}
