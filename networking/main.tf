variable "vpc_cidr" {}
variable "vpc_name" {}
variable "cidr_public_subnet" {}
variable "cidr_private_subnet" {}
variable "us_availability_zone" {}

output "prod-desqk-vpc-id" {
    value = aws_vpc.prod-desqk-us-west-2-vpc.id
}

output "prod-desqk-vps-public-subnets" {
    value = aws_subnet.prod-desqk-public-subnets.*.id
}

# Setup VPC
resource "aws_vpc" "prod-desqk-us-west-2-vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_name
    }
}

# Setup public subnet
resource "aws_subnet" "prod-desqk-public-subnets" {
    count             = length(var.cidr_public_subnet)
    vpc_id            = aws_vpc.prod-desqk-us-west-2-vpc.id
    cidr_block        = element(var.cidr_public_subnet, count.index)
    availability_zone = element(var.us_availability_zone, count.index)

    tags = {
        Name = "prod-desqk-public-subnet-${ count.index + 1 }"
    }
}

# Setup private subnet
resource "aws_subnet" "prod-desqk-private-subnets" {
    count             = length(var.cidr_private_subnet)
    vpc_id            = aws_vpc.prod-desqk-us-west-2-vpc.id
    cidr_block        = element(var.cidr_private_subnet, count.index)
    availability_zone = element(var.us_availability_zone, count.index)

    tags = {
        Name = "prod-desqk-private-subnet-${count.index + 1}"
    }
}

# Setup Internet Gateway
resource "aws_internet_gateway" "prod-desqk-igw" {
    vpc_id = aws_vpc.prod-desqk-us-west-2-vpc.id
    tags = {
        Name = "prod-desqk-igw"
    }
}

# Public Route Table
resource "aws_route_table" "prod-desqk-public-rt" {
    vpc_id = aws_vpc.prod-desqk-us-west-2-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.prod-desqk-igw.id
    }
    tags = {
        Name = "prod-desqk-public-rt"
    }
}

# Private Route Table
resource "aws_route_table" "prod-desqk-private-rt" {
    vpc_id = aws_vpc.prod-desqk-us-west-2-vpc.id
    tags = {
        Name = "prod-desqk-private-rt"
    }
}

# Public Route Table & Subnet Association
resource "aws_route_table_association" "prod-desqk-public-rt-subnet-association" {
    count          = length(aws_subnet.prod-desqk-public-subnets)
    subnet_id      = aws_subnet.prod-desqk-public-subnets[count.index].id
    route_table_id = aws_route_table.prod-desqk-public-rt.id
}

# Private Route Table & Subnet Association
resource "aws_route_table_association" "dev_proj_1_private_rt_subnet_association" {
    count          = length(aws_subnet.prod-desqk-private-subnets)
    subnet_id      = aws_subnet.prod-desqk-private-subnets[count.index].id
    route_table_id = aws_route_table.prod-desqk-private-rt.id
}