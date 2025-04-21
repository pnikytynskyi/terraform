locals {
  common_tags = {
    ManagedBy  = "Terraform"
    Project    = "07-data-sources"
    CostCenter = "1234"
  }
}

resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"

  tags = merge(local.common_tags, {
    Name = "07-data-sources"
  })
}

resource "aws_route_table" "dev_public" {
  vpc_id = aws_vpc.dev.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev.id
  }

  tags = merge(local.common_tags, {
    Name = "07-data-sources-public"
  })
}

resource "aws_internet_gateway" "dev" {
  vpc_id = aws_vpc.dev.id
  tags = merge(local.common_tags, {
    Name = "07-data-sources"
  })
}


resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.0.0/24"
}