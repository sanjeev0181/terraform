terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"

}

# creating instance
resource "aws_instance" "ec2-instance-sg" {
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
 
  # adding the security group to instance

  vpc_security_group_ids = [aws_security_group.allowing_sg.id]
  tags = {
    Name = "instance-tf-1"
  }
}

# creating security group
resource "aws_security_group" "allowing_sg" {
  name = "allowing_sg"

  description = "Allow TLS inbound traffic"
  # vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}