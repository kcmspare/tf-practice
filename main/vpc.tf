# VPC

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main_vpc"
  cidr = "10.0.0.0/16"

   azs = ["us-east-1a", "us-east-1b"]
   private_subnets = ["10.0.1.0/24", "10.0.3.0/24"]
   public_subnets = ["10.0.0.0/24", "10.0.2.0/24"]
   
   enable_nat_gateway = true
   enable_vpn_gateway = false
}

resource "aws_db_subnet_group" "gitlab_private_subnets" {
  name       = "gitlab_subnet_private"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_elasticache_subnet_group" "gitlab_EC_subnet_group" {
  name       = "gitlab-ec-subnet-group"
  subnet_ids = module.vpc.private_subnets
}