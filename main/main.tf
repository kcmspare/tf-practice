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




