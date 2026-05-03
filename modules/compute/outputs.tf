output "server_public_ip" {
  description = "The address of server EC2 "
  value = aws_instance.free_tier.public_ip
}
output "server_id" {
  description = "ID of the server"
  value = aws_instance.free_tier.id
}
output "server_public_dns" {
  description = "Public DNS của máy chủ"
  value       = aws_instance.free_tier.public_dns
}