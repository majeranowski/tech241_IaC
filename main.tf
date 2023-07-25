provider "aws" {
  region = "eu-west-1"
}

# Create VPC
resource "aws_vpc" "tech241_krzysztof_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tech241-krzysztof-terraform-vpc"
  }
}

# Create public subnet
resource "aws_subnet" "tech241_krzysztof_public_subnet" {
  vpc_id     = aws_vpc.tech241_krzysztof_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1a" # Replace with your desired AZ

  tags = {
    Name = "tech241-krzysztof-public-subnet"
  }
}

# Create private subnet
resource "aws_subnet" "tech241_krzysztof_private_subnet" {
  vpc_id     = aws_vpc.tech241_krzysztof_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-1b" # Replace with your desired AZ

  tags = {
    Name = "tech241-krzysztof-private-subnet"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "tech241_krzysztof_igw" {
  vpc_id = aws_vpc.tech241_krzysztof_vpc.id
}

# Create route table for public subnet
resource "aws_route_table" "tech241_krzysztof_public_route_table" {
  vpc_id = aws_vpc.tech241_krzysztof_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tech241_krzysztof_igw.id
  }
}

# Associate the public route table with the public subnet
resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.tech241_krzysztof_public_subnet.id
  route_table_id = aws_route_table.tech241_krzysztof_public_route_table.id
}

# Create security group for the public subnet
resource "aws_security_group" "app_sg" {
  name_prefix = "app_sg_"

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.tech241_krzysztof_vpc.id
}

# Create security group for the private subnet
resource "aws_security_group" "db_sg" {
  name_prefix = "db_sg_"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow MongoDB"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.tech241_krzysztof_vpc.id
}

# Create an EC2 instance in the public subnet
resource "aws_instance" "app_instance" {
  ami           = var.webapp_ami_id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id     = aws_subnet.tech241_krzysztof_public_subnet.id
  vpc_security_group_ids = [
    aws_security_group.app_sg.id,
  ]

  tags = {
    Name = "tech241-krzysztof-terraform-app"
  }
}
