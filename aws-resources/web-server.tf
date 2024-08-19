provider "aws" {
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::533267077438:role/deployer-role"
    session_name = "terraform"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "s3-dev-tf-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "dev"
  }
}