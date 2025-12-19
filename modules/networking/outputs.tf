output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.three_tier_vpc.id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_app_subnets" {
  description = "List of IDs of private app subnets"
  value       = aws_subnet.private_app[*].id
}

output "private_db_subnets" {
  description = "List of IDs of private db subnets"
  value       = aws_subnet.private_db[*].id
}
