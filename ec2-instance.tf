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
resource "aws_instance" "test" {
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  key_name      = "id_rsa.pub"
  # adding the security group to instance

  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  tags = {
    Name = "instance-tf-1"
  }
}

# creating security group
resource "aws_security_group" "allow_tls" {
  name = "allow_tls"

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

#making ssh connection
resource "aws_key_pair" "deployer" {
  key_name   = "id_rsa.pub"
  public_key = file("~/.ssh/id_rsa.pub")
}


#creating s3 bucket in aws

resource "aws_s3_bucket" "first"{
    bucket = "simple-tf-b.0.1"

}

#uploding the files to s3-buckets

resource "aws_s3_bucket_object" "buckets_s3v"{
    bucket = aws_s3_bucket.first.id
    key = "terraform.tfstate"
    source ="/home/ubuntu/terraform-practise/terraform.tfstate"

}

# uploding multiple files

resource "aws_s3_bucket_object" "multiples3files"{
   bucket =aws_s3_bucket.first.id
   for_each=fileset("/home/ubuntu/tf-dummy-files","*")
   key = each.value
   source ="/home/ubuntu/tf-dummy-files/${each.value}"
}
/*#creating key-pair using tf script

resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}*/
