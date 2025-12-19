output "db_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.three_tier_db.endpoint
}

output "db_port" {
  description = "The port of the RDS instance"
  value       = aws_db_instance.three_tier_db.port
}
