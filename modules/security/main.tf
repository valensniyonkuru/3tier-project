# ALB Security Group (Public)
resource "aws_security_group" "alb_sg" {
  name        = "three_tier_alb_sg"
  description = "Allow HTTP/HTTPS from anywhere"
  vpc_id      = var.vpc_id

  tags = {
    Name = "three_tier_alb_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


# App Security Group (Private)
resource "aws_security_group" "app_sg" {
  name        = "three_tier_app_sg"
  description = "Allow traffic from ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "three_tier_app_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

# The assignment hints mention allowing ICMP for ping test from ALB or Jump Server
resource "aws_vpc_security_group_ingress_rule" "app_icmp" {
  security_group_id            = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = -1
  ip_protocol                  = "icmp"
  to_port                      = -1
}

resource "aws_vpc_security_group_egress_rule" "app_egress" {
  security_group_id = aws_security_group.app_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


# Database Security Group (Private)
resource "aws_security_group" "db_sg" {
  name        = "three_tier_db_sg"
  description = "Allow traffic from App Tier"
  vpc_id      = var.vpc_id

  tags = {
    Name = "three_tier_db_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.db_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = 3306 # MySQL default
  ip_protocol                  = "tcp"
  to_port                      = 3306
}

resource "aws_vpc_security_group_egress_rule" "db_egress" {
  security_group_id = aws_security_group.db_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
