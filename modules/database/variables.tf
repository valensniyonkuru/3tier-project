variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the DB subnet group"
}

variable "security_group_id" {
  type        = string
  description = "The security group ID for the RDS instance"
}

variable "db_name" {
  type        = string
  description = "The name of the database"
  default     = "threetierdb"
}

variable "db_password" {
  type        = string
  description = "The password for the database"
  default     = "ChangeMe123!" # In real env, use secrets manager or input variable without default
  sensitive   = true
}
