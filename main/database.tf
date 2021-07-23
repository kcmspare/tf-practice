# Databases

resource "aws_rds_cluster" "DB_gitlab" {
  cluster_identifier      = "aurora-cluster-gitlab"
  engine                  = "aurora-postgresql"
  engine_mode = "serverless"
  availability_zones      = ["us-east-1a", "us-east-1b"]
  database_name           = "gitlab_db"
  master_username         = "Should_not_be_stored_here"
  master_password         = "temp_password_for_testing_dont_really_put_stuff_here"
  backup_retention_period = 7
  preferred_backup_window = "03:00-07:00"
  storage_encrypted =   true
  kms_key_id = aws_kms_key.key_gitlab_db.arn
  vpc_security_group_ids = [aws_security_group.gitlab-rds.id]
  db_subnet_group_name = aws_db_subnet_group.gitlab_private_subnets.id
  skip_final_snapshot = "true"
  apply_immediately = true
}

resource "aws_kms_key" "key_gitlab_db" {
  description             = "KMS key for Gitlab primary DB"
  deletion_window_in_days = 7
}

resource "aws_elasticache_replication_group" "gitlab_redis" {
  automatic_failover_enabled    = true
  availability_zones            = module.vpc.azs
  node_type                     = "cache.t2.small"
  number_cache_clusters         = 2
  replication_group_id          = "gitlab-redis-replicationgroup"
  replication_group_description = "redis replication group for gitlab"
  transit_encryption_enabled    = true
  at_rest_encryption_enabled    = true
  kms_key_id                    = aws_kms_key.key_gitlab_db.arn
  security_group_ids            = [aws_security_group.gitlab-redis.id]
  subnet_group_name             = aws_elasticache_subnet_group.gitlab_EC_subnet_group.name
}
