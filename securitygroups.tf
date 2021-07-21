# Security groups

resource "aws_security_group" "gitlab-loadbalancer" {
  name        = "gitlab-loadbalancer"
  description = "gitlab load balancer security group"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group" "gitlab-bastion" {
# This is inside gitlab-loadbalancer
  name        = "gitlab-bastion"
  description = "gitlab bastion security group"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group" "gitlab-gitaly" {
  name        = "gitlab-gitaly"
  description = "gitlab gitaly security group"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group" "gitlab-runner" {
  name        = "gitlab-runner"
  description = "gitlab runner security group"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group" "gitlab-rds" {
  name        = "gitlab-rds"
  description = "gitlab RDS security group"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group" "gitlab-redis" {
  name        = "gitlab-redis"
  description = "gitlab redis security group"
  vpc_id      = module.vpc.vpc_id
}