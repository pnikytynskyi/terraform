resource "aws_instance" "web" {
  # nginx "ami-0e0142bb01c0a1b88"
  # ubuntu "ami-012a41984655c6c83"
  ami                         = data.aws_ami.ubuntu_focal_eu.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.public_http_traffic.id]

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp3"
    volume_size           = 10
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "public_http_traffic" {
  description = "Security group allowing traffic on ports 443 and 80"
  name        = "public-http-traffic"
  vpc_id      = aws_vpc.dev.id
}

# Look up the latest Ubuntu 20.04 AMI

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


output "ubuntu_ami_data_eu" {
  value = data.aws_ami.ubuntu_focal_eu.id
}

