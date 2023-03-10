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


# creating secruity groups
resource "aws_security_group" "tf-jenkins-s3-allow_tls-01" {
  name = "tf-jenkins-s3-allow_tls-01"

  description = "Allow ACCESS ON PORTS 8080 AND 22"
  # vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh port allowing"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "jenkins port allowing"
    from_port   = 8080
    to_port     = 8080
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
    Name = "tf_jenkins_s3_security"
  }
}

#making ssh connection
resource "aws_key_pair" "tf-jenkins" {
  key_name   = "id_rsa_tf_jenkins_s3.pub"
  public_key = file("/home/ubuntu/.ssh/id_rsa.pub")
}

# creating instance
resource "aws_instance" "tf-jenkins-s3" {
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  key_name      = "id_rsa_tf_jenkins_s3.pub"
  # adding the security group to instance

  vpc_security_group_ids = [aws_security_group.tf-jenkins-s3-allow_tls-01.id]
  tags = {
    Name = "jenkins-server"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install openjdk-8-jdk -y",
      "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
      "sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "sudo apt-get update -y",
      "sudo apt upgrade -y",
      "sudo apt-get install jenkins -y",
      "sudo apt install git -y",
      "sudo systemctl enable jenkins",
      "sudo systemctl start jenkins",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    ]
  }
  connection {
    type = "ssh"
    #host        = "aws_instance.tf-jenkins-s3.public_ip"
    host        = "self.public_ip"
    user        = "ubuntu"
    private_key = file("/home/ubuntu/terraform-practise/tf_jenkins_s3/privatekey/mainkey.pem")
  }
}

