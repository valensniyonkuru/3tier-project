variable "instance_type" {
  type        = string
  description = "The type of instance to start"
  default     = "t3.micro"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for ASG"
}

variable "security_group_id" {
  type        = string
  description = "The security group ID for the app instances"
}

variable "target_group_arn" {
  type        = string
  description = "The ARN of the target group to attach to the ASG"
}

variable "public_subnet_id" {
  type        = string
  description = "Public subnet ID for Bastion"
}

variable "bastion_sg_id" {
  type        = string
  description = "Security group for Bastion"
}

variable "key_name" {
  type        = string
  description = "Key pair name for instances"
}
