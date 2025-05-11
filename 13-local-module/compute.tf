locals {
  project_name = "13-local-modules"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "this" {
  # nginx "ami-0e0142bb01c0a1b88"
  # ubuntu "ami-012a41984655c6c83"
  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.private_subnets["subnet_1"].subnet_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({}, {
    ManagedBy = "Terraform"
    Name      = "${local.project_name}-this"
  })
}