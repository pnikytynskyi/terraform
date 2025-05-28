locals {
  project       = "08-input-vars-locals-outputs"
  project_owner = "terraform"
  cost_center   = "1234"
  managed_by    = "Terraform"
}

locals {
  common_tags = {
    project       = local.project
    project_owner = local.project_owner
    cost_center   = local.cost_center
    managed_by    = local.managed_by
    # sensitive_tag = var.my_sensitivity_info
  }
}

resource "aws_instance" "compute" {
  # nginx "ami-0e0142bb01c0a1b88"
  # ubuntu "ami-012a41984655c6c83"
  ami                         = data.aws_ami.ubuntu_focal_eu.id
  associate_public_ip_address = true
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public_http_traffic.id]

  root_block_device {
    delete_on_termination = true
    volume_type = var.ec2_volume_config.type
    volume_size = var.ec2_volume_config.size
  }
  
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.additional_tags, local.common_tags)
}

locals {
  ec2_instance_type = var.ec2_instance_type
}

data "aws_ami" "ubuntu_focal_eu" {
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