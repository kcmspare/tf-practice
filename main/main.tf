provider aws {
  region = "us-east-1"
  access_key = var.AWS_access_key
  secret_key = var.AWS_secret_key
  
  default_tags {
      tags = {
          terraform = "true/github"
          use = "Kanchimoe/Gitlab on AWS"
      }
  }
}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

provider "docker" {
  host = "tcp://localhost:2375"
}
