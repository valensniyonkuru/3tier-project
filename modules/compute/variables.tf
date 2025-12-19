variable "instance_type" {
  type        = string
  description = "The type of instance to start"
  default     = "t3.micro"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs where instances will be launched"
}

variable "security_group_id" {
  type        = string
  description = "The security group ID for the instances"
}

variable "target_group_arn" {
  type        = string
  description = "The ARN of the target group to attach to the ASG"
}
