output "NAT-Instance" {
  value = "${aws_eip.nat.public_ip}"
}

output "WEB-Instance" {
  value = "${aws_eip.web-1.public_ip}"
}
