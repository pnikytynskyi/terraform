terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "eu-central-1"

}

provider "aws" {
  region = "eu-west-1"
  alias  = "eu-west"
}

resource "aws_s3_bucket" "eu-central_bucket" {
  bucket = "my-tf-test-bucket-12312312312312"
}
resource "aws_s3_bucket" "eu-west_bucket" {
  bucket   = "my-tf-test-bucket-1231231231231233"
  provider = "aws.eu-west"
}