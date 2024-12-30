terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "store-mag-tfstate-bucket" // bucket name
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "store-mag-terraform-lock-state" // dynamodb table name
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

resource "aws_ecs_cluster" "main" {
  name = "store-mag-cluster"
}
