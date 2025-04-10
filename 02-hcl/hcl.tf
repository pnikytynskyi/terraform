terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.37.0"
    }
  }
}

# Managed by terraform
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}

# Managed somewhere else
data "aws_s3_bucket" "my_external_bucket" {
  bucket = "not-mnaged-by-us"
}

variable "bucket_name" {
  description = "Name of the bucket"
  default     = "notice-media-io-com"
  type = string
}

output "bucket_id" {
  value = aws_s3_bucket.my_bucket.id
}

locals {
  local_example = "local variable"
}

module "my_module" {
  source = ""
}