locals {
  common_tags = {
    ManagedBy  = "Terraform"
    Project    = "06-resources-dev"
    CostCenter = "1234"
  }
}

resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"

  tags = merge(local.common_tags, {
    Name = "06-resources"
  })
}

resource "aws_route_table" "dev_public" {
  vpc_id = aws_vpc.dev.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev.id
  }

  tags = merge(local.common_tags, {
    Name = "06-resources-public"
  })
}

resource "aws_internet_gateway" "dev" {
  vpc_id = aws_vpc.dev.id
  tags = merge(local.common_tags, {
    Name = "06-resources-dev"
  })
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.0.0/24"
  tags = merge(local.common_tags, {
    Name = "06-resources-public"
  })
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.dev_public.id
  subnet_id      = aws_subnet.public.id
}