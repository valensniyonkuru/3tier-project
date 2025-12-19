variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnets_cidr" {
  type        = list(string)
  description = "List of CIDR blocks for private app subnets"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_db_subnets_cidr" {
  type        = list(string)
  description = "List of CIDR blocks for private db subnets"
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
  default     = ["eu-central-1a", "eu-central-1b"]
}
