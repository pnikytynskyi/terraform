locals {
  private_subnets = ["10.0.1.0/24"]
  public_subnets = ["10.0.124.0/24"]
  vpc_cidr     = "10.0.0.0/16"
  project_name = "12-public-modules"
  common_tags = {
    ManagedBy = "terraform"
    Project   = local.project_name
  }
}

