terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19.0"
    }
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "s3-dev-tf-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "dev"
  }
}
