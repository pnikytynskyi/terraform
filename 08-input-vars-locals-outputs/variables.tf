variable "aws_region" {
  default = "eu-central-1"
  type    = string
}

variable "ec2_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Managed EC2 instance size"
  validation {
    condition = contains(["t2.micro", "t3.micro"], var.ec2_instance_type)
    error_message = "The ec2_instance_type must be one of t2.micro, t2.small, t2.medium, t2.large, t2.xlarge, t2.2xlarge."
  }
}


variable "ec2_volume_config" {
  type = object({
    size = number
    type = string
  })
  description = "The size(GB) and the type of the root volume attached to the managed EC2 instance. "

  default = {
    size = 10
    type = "gp2"
  }
}