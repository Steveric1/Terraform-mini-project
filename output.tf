output "Application_LB_DNS" {
  value = aws_lb.ALB.dns_name
}

output "zone_id" {
  value = aws_lb.ALB.zone_id
}

output "web1_ipaddress" {
  value = aws_instance.web1.public_ip
}

output "web2_ipaddress" {
  value = aws_instance.web2.public_ip
}

output "web3_ipaddress" {
  value = aws_instance.web3.public_ip
}