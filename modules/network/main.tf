resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}" # range of IP addresses for the VPC
  tags = {
    name = "my-vpc"
    Environment = "dev"
    ManagedBy = "Terraform"
  }
  enable_dns_hostnames = true
  tags_all = {
    name = "my-vpc"
    Environment = "dev"
    ManagedBy = "Terraform"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "${var.public_subnet_cidr}" # range of IP addresses for the subnet
  availability_zone = "${var.availability_zone}" 
    tags = {
        name = "public-subnet"
        Environment = "dev"
        ManagedBy = "Terraform"
    }
}
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "${var.private_subnet_cidr}" # range of IP addresses for the subnet
  availability_zone = "${var.availability_zone}" 
        tags = {
            name = "private-subnet"
            Environment = "dev"
            ManagedBy = "Terraform"
        }
  
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
    tags = {
        name = "public-route-table"
        Environment = "dev"
        ManagedBy = "Terraform"
    }
}
resource "aws_route_table" "associate_private_subnet" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "associate_public_subnet" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        name = "private-route-table"
        Environment = "dev"
        ManagedBy = "Terraform"
    }
  
}
resource "aws_route_table_association" "public_subnet_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.associate_public_subnet.id
  
}
resource "aws_route_table_association" "private_subnet_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.associate_private_subnet.id
  
}