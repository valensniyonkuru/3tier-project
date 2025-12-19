variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "subnets" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "security_group_id" {
  type        = string
  description = "The security group ID for the ALB"
}
