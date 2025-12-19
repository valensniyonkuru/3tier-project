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
}

# Create Database Module
module "database" {
  source            = "./modules/database"
  subnet_ids        = module.networking.private_db_subnets
  security_group_id = module.security.db_sg_id
}
