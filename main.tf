terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "nest-ecs-tfstate-bucket" // bucket name
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "nest-ecs-terraform-lock-state" // dynamodb table name
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "allow_db" {
  name        = "allow_db"
  description = "Allow DB"

  ingress {
    from_port        = 5430
    to_port          = 5440
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_ecs_cluster" "main" {
  name = "store-mag-cluster"
}
