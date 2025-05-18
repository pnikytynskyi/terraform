module "networking-tf" {
  source = "pnikytynskyi/networking-tf/aws"
  version = "0.1.1"
  # insert the 2 required variables here
  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name       = "14-use-own-modle"
  }
  subnet_config = {
    subnet_1 = {
      cidr_block = "10.0.0.0/24"
      az         = "eu-central-1a"
    }
    subnet_2 = {
      cidr_block = "10.0.1.0/24"
      public     = true
      az         = "eu-central-1b"
    }
  }
}