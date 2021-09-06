output "gitlab_db_redis_endpoint" {
  value = aws_rds_cluster.DB_gitlab.endpoint
}
