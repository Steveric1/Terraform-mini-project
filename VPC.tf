#Create virtual private cloud
resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr
  instance_tenancy = "default"

  tags = {
    Name = "project-vpc"
  }
}

#create a public subnet
data "aws_availability_zones" "AZ" {}
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub1_sub
  availability_zone       = data.aws_availability_zones.AZ.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "project-pub1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub2_sub
  availability_zone       = data.aws_availability_zones.AZ.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "project-pub2"
  }
}

resource "aws_subnet" "public3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub3_sub
  availability_zone       = data.aws_availability_zones.AZ.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "project-pub3"
  }
}

#create a private subnet
resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.priv1_sub
  availability_zone       = data.aws_availability_zones.AZ.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "project-priv1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.priv2_sub
  availability_zone       = data.aws_availability_zones.AZ.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "project-priv2"
  }
}

resource "aws_subnet" "private3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.priv3_sub
  availability_zone       = data.aws_availability_zones.AZ.names[2]
  map_public_ip_on_launch = false

  tags = {
    Name = "project-priv3"
  }
}

#Create a route table
resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.route
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "project-route"
  }
}

#Create route table association to seperate my public subnet from my private subnet 
resource "aws_route_table_association" "pub1-association" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pub2-association" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pub3-association" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.pub.id
}

#Create internet gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "project-IGW"
  }
}

#Create a security group for this vpc
resource "aws_security_group" "allow_traffic" {
  name        = "traffic"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.web_ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project-groups"
  }
}
