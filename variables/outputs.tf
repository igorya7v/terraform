output "public_ip" {
  value = aws_eip.webserver.public_ip
}

output "server_id" {
  value = aws_instance.webserver.id
}

output "security_group_id" {
  value = aws_security_group.webserver.id
}
