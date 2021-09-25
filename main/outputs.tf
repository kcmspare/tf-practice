output "gitlab_db_redis_endpoint" {
  value = aws_rds_cluster.DB_gitlab.endpoint
}

output "gitlab_db_redis_port" {
  value = aws_rds_cluster.DB_gitlab.port
}

output "gitlab_efs_arn" {
  value = aws_efs_file_system.gitlab_efs.arn
}
