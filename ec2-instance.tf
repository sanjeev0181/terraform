terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  access_key = "AKIAXSUFX6EHGB6OOINC"
  secret_key = "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"
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  user_data = <<EOF
#!/bin/bash
sudo apt update 
sudo apt install nginx
EOF
    }

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
