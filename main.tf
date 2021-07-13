provider aws {
  region = "us-east-1"
  
  default_tags {
      tags = {
          terraform = "true/github"
          use = "Kanchimoe/Gitlab on AWS"
      }
  }
}