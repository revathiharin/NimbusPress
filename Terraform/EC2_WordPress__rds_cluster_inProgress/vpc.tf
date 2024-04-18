# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = "vpc_2024_02_23"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw_2024_02_23"
  }
}
/* 
# Create Elastic IP
resource "aws_eip" "nat_gateway" {
  #vpc = true
  
  tags = {
    Name = "eip_2024_02_23"
  }
}
# Create NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "nat_2024_02_23"
  }
} */


# Create Public Subnets
resource "aws_subnet" "public" {
  count                = length(var.public_subnet_cidr_blocks)
  vpc_id               = aws_vpc.main.id
  cidr_block           = var.public_subnet_cidr_blocks[count.index]
  availability_zone    = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 2024 02 23_ ${count.index + 1}"
  }   

}

# Create Private Subnets
resource "aws_subnet" "private" {
  count                = length(var.private_subnet_cidr_blocks)
  vpc_id               = aws_vpc.main.id
  cidr_block           = var.private_subnet_cidr_blocks[count.index]
  availability_zone    = var.availability_zones[count.index % length(var.availability_zones)]

  tags = {
    Name = "Private Subnet 2024 02 23_${count.index + 1}"
  }
}

# Create Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.cidr_blocks[0]
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public Route Table 2024 02 23"
  }
}

resource "aws_route_table" "private" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private Route Table 2024 02 23_${count.index + 1}"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_assoc" {
  count        = length(var.public_subnet_cidr_blocks)
  subnet_id    = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate Private Subnets with Private Route Tables
resource "aws_route_table_association" "private_assoc" {
  count        = length(var.private_subnet_cidr_blocks)
  subnet_id    = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
