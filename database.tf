# Databases

resource "aws_rds_cluster" "DB_gitlab" {
  cluster_identifier      = "aurora-cluster-gitlab"
  engine                  = "aurora-postgresql"
  engine_mode = "serverless"
  availability_zones      = ["us-east-1a", "us-east-1b"]
  database_name           = "gitlab_db"
  master_username         = "Should_not_be_stored_here"
  master_password         = "hunter2"
  backup_retention_period = 7
  preferred_backup_window = "03:00-07:00"
  storage_encrypted =   true
  kms_key_id = aws_kms_key.key_gitlab_db.arn
  #vpc_security_group_ids = <to set up>
}

resource "aws_kms_key" "key_gitlab_db" {
  description             = "KMS key for Gitlab primary DB"
  deletion_window_in_days = 7
}

