module "login-system-vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "v5.0.0"
  name            = "login-system-vpc"
  cidr            = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks
  azs             = ["ap-south-1a", "ap-south-1b"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "kubernetes.io/cluster/login-systems" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/login-systems" = "shared"
    "kubernetes.io/role/elb"                  = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/login-systems" = "shared"
    "kubernetes.io/role/internal-elb"         = 1
  }
}