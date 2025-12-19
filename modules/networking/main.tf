# Create VPC
resource "aws_vpc" "three_tier_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "three_tier_vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.three_tier_vpc.id

  tags = {
    Name = "three_tier_igw"
  }
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.three_tier_vpc.id
  cidr_block              = var.public_subnets_cidr[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

# Create Private App Subnets
resource "aws_subnet" "private_app" {
  count             = length(var.private_app_subnets_cidr)
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = var.private_app_subnets_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "private_app_subnet_${count.index + 1}"
  }
}

# Create Private DB Subnets
resource "aws_subnet" "private_db" {
  count             = length(var.private_db_subnets_cidr)
  vpc_id            = aws_vpc.three_tier_vpc.id
  cidr_block        = var.private_db_subnets_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "private_db_subnet_${count.index + 1}"
  }
}

# Create Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rtb"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create EIP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# Create NAT Gateway (in the first public subnet)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "three_tier_nat"
  }
  depends_on = [aws_internet_gateway.igw]
}

# Create Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.three_tier_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private_rtb"
  }
}

# Associate Private App Subnets with Private Route Table
resource "aws_route_table_association" "private_app" {
  count          = length(var.private_app_subnets_cidr)
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private.id
}

# Associate Private DB Subnets with Private Route Table
resource "aws_route_table_association" "private_db" {
  count          = length(var.private_db_subnets_cidr)
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private.id
}
