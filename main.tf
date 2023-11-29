# main.tf

provider "aws" {
  region = "us-east-1"  # Change this to your desired AWS region
}

resource "aws_key_pair" "terraform-key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")  
}

resource "aws_instance" "ubuntu_instance" {
  ami           = "ami-0fc5d935ebf8bc3bc"

  instance_type = "t2.micro"

  key_name      = aws_key_pair.terraform-key.key_name

  tags = {
    Name = "terraform-instance"
  }
}









# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}

# Create a security group for web servers
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.my_vpc.id

  # Inbound rule allowing HTTP traffic
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rule allowing SSH traffic for administration
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule allowing all traffic
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags for the security group
  tags = {
    Name = "web-sg"
  }
}

# Create a security group for database servers
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Security group for database servers"
  vpc_id      = aws_vpc.my_vpc.id

  # Inbound rule allowing database connections
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # Outbound rule allowing all traffic
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags for the security group
  tags = {
    Name = "db-sg"
  }
}

