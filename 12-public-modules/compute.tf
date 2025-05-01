locals {
  instance_type = "t2.micro"
}
module "ec2-instance" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  version       = "5.8.0"
  name          = local.project_name
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id     = module.vpc.public_subnets[0]
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