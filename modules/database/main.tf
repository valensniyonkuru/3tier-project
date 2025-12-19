# Create DB Subnet Group
resource "aws_db_subnet_group" "three_tier_db_subnet_group" {
  name       = "three_tier_db_subnet_group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "three_tier_db_subnet_group"
  }
}

# Create RDS Instance
resource "aws_db_instance" "three_tier_db" {
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.three_tier_db_subnet_group.name

  tags = {
    Name = "three_tier_rds"
  }
}
