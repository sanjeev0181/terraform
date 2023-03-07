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



# creating security group
resource "aws_security_group" "tf-jenkins-s3-allow_tls" {
  name = "tf-jenkins-s3-allow_tls"

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
    Name = "allow_tls-jenkins"
  }
}



# creating instance
resource "aws_instance" "tf-jenkins-s3" {
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  key_name      = "id_rsa_tf_jenkins_s3.pub"
  # adding the security group to instance

  vpc_security_group_ids = [aws_security_group.tf-jenkins-s3-allow_tls.id]
  tags = {
    Name = "tf-jenkins-s3"
  }
}

#making ssh connection
resource "aws_key_pair" "tf-jenkins" {
  key_name   = "id_rsa_tf_jenkins_s3.pub"
  public_key = file("/home/ubuntu/.ssh/id_rsa.pub")
}

resource "null_resource" "tf-jenkins" {
  # ssh into the ec2 instance
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/ubuntu/terraform-practise/tf_jenkins_s3/privatekey/mainkey.pem")
    host        = aws_instance.tf-jenkins-s3.public_ip
  }
  #setting permissions and runs jenkins-installation.sh file
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /home/ubuntu/terraform-practise/tf_jenkins_s3/privatekey/mainkey.pem",
      "sudo chmod +x /home/ubuntu/terraform-practise/tf_jenkins_s3/jenkins-installation.sh",
      "sh /home/ubuntu/terraform-practise/tf_jenkins_s3/jenkins-installation.sh",
    ]
  }
}

#print the url of the jenkins server
output "website_url" {
  value = join("", ["http://", aws_instance.tf-jenkins-s3.public_dns, ":", "8080"])
}

