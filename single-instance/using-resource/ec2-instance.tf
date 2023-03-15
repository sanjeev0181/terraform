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
  region = "ap-south-1"

}


# creating instance
resource "aws_instance" "ec2-instance" {
  ami           = "ami-0f8ca728008ff5af4"
  instance_type = "t2.micro"
  # adding the security group to instance
  vpc_security_group_ids = [aws_security_group.allowing_sg.id]

  #sending some data using user-data 
  user_data = "${file("sample.sh")}"
    
  

  # adding key-pair 
  key_name      = "id_rsa.pub"
  tags = {
    Name = "ec2-instance-tf-1"
  }
}