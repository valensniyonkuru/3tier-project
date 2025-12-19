variable "vpc_id" {
  type        = string
  description = "The VPC ID where security groups will be created"
}

variable "my_ip" {
  type        = string
  description = "IP address allowed to SSH into Bastion"
  default     = "0.0.0.0/0" # In prod, restrict this!
}
