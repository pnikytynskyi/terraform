


data "aws_availability_zones" "azs" {
  state = "available"
}



module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.5.3"

  azs = data.aws_availability_zones.azs.names
  cidr = local.vpc_cidr
  name = local.project_name
  private_subnets = local.private_subnets
  public_subnets = local.public_subnets

  tags = merge(local.common_tags, {})
}