# resource "aws_instance" "web" {
#   # nginx "ami-0e0142bb01c0a1b88"
#   # ubuntu "ami-012a41984655c6c83"
#   ami                         = "ami-012a41984655c6c83"
#   associate_public_ip_address = true
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.public.id
#   vpc_security_group_ids = [aws_security_group.public_http_traffic.id]
#   tags = merge(local.common_tags, {
#     Name = "06-resources-ec2"
#   })
#   root_block_device {
#     delete_on_termination = true
#     volume_type           = "gp3"
#     volume_size           = 10
#   }
#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_security_group" "public_http_traffic" {
  description = "Security group allowing traffic on ports 443 and 80"
  name        = "public-http-traffic"
  vpc_id      = aws_vpc.dev.id
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  tags = merge(local.common_tags, {
    Name = "06-resources-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
}