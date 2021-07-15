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

resource "aws_elasticache_replication_group" "gitlab_redis_primary" {
  replication_group_description = "gitlab redis primary"
  replication_group_id = "gitlab-redis-primary-cluster"
  at_rest_encryption_enabled = true
  kms_key_id = aws_kms_key.key_gitlab_db.arn
  node_type = "cache.t2.small"
  #security_group_ids = <to set up>
  #cluster-enabled = to look into
  parameter_group_name = "gitlab.redis.primary"
  automatic_failover_enabled = true

  cluster_mode {
    replicas_per_node_group = 1
    num_node_groups = 2
  }
}

