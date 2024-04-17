# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc ${var.tagNameDate}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw ${var.tagNameDate}"
  }
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_Subnet ${var.tagNameDate}_${count.index + 1}"
  }

}

# Create Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

  tags = {
    Name = "Private_Subnet ${var.tagNameDate}_${count.index + 1}"
  }
}

# Create Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.cidr_blocks[0]
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public_Route_Table ${var.tagNameDate}"
  }
}

resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Private_Route_Table ${var.tagNameDate}_${count.index + 1}"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate Private Subnets with Private Route Tables
resource "aws_route_table_association" "private_assoc" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
