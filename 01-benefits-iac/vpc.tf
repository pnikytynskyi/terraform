terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "iac_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Terraform VPC"
  }
}

resource "aws_subnet" "iac_public_subnet" {
  vpc_id = aws_vpc.iac_vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "iac_private_subnet" {
  vpc_id = aws_vpc.iac_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "iac_igw" {
  vpc_id = aws_vpc.iac_vpc.id
}

resource "aws_route_table" "iac_rt_public" {
  vpc_id = aws_vpc.iac_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iac_igw.id
  }
}

resource "aws_route_table_association" "iac_rt_association_public_subnet" {
  subnet_id = aws_subnet.iac_public_subnet.id
  route_table_id = aws_route_table.iac_rt_public.id
}