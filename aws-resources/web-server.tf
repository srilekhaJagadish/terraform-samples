provider "aws" {
    region = "eu-west-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "s3-dev-tf-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "dev"
  }
}