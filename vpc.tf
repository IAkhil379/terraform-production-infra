resource "aws_vpc" "prod_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "prod-vpc" }
}

# --- PUBLIC SUBNETS ---
resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "prod-public-1a" }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags              = { Name = "prod-public-1b" }
}

# --- PRIVATE SUBNETS ---
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "prod-private-1a" }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1b"
  tags              = { Name = "prod-private-1b" }
}

# --- INTERNET GATEWAY & NAT GATEWAY ---
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod_vpc.id
  tags   = { Name = "prod-igw" }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id
  tags          = { Name = "prod-nat-gw" }
}

# --- ROUTE TABLES ---
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.prod_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.prod_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

# --- ASSOCIATIONS ---
resource "aws_route_table_association" "pub_1" { subnet_id = aws_subnet.public_1.id; route_table_id = aws_route_table.public_rt.id }
resource "aws_route_table_association" "pub_2" { subnet_id = aws_subnet.public_2.id; route_table_id = aws_route_table.public_rt.id }
resource "aws_route_table_association" "priv_1" { subnet_id = aws_subnet.private_1.id; route_table_id = aws_route_table.private_rt.id }
resource "aws_route_table_association" "priv_2" { subnet_id = aws_subnet.private_2.id; route_table_id = aws_route_table.private_rt.id }
