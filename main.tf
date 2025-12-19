# Create Key Pair
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "three_tier_kp"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename        = "${aws_key_pair.kp.key_name}.pem"
  content         = tls_private_key.pk.private_key_pem
  file_permission = "0400"
}

# Create Networking Module
module "networking" {
  source = "./modules/networking"
}

# Create Security Module
module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
}

# Create ALB Module
module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.networking.vpc_id
  subnets           = module.networking.public_subnets
  security_group_id = module.security.alb_sg_id
}

# Create Compute Module
module "compute" {
  source            = "./modules/compute"
  subnet_ids        = module.networking.private_app_subnets
  security_group_id = module.security.app_sg_id
  target_group_arn  = module.alb.target_group_arn

  # New variables for Bastion
  public_subnet_id = module.networking.public_subnets[0]
  bastion_sg_id    = module.security.bastion_sg_id
  key_name         = aws_key_pair.kp.key_name
}

# Create Database Module
module "database" {
  source            = "./modules/database"
  subnet_ids        = module.networking.private_db_subnets
  security_group_id = module.security.db_sg_id
}
