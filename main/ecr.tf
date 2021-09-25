resource "aws_ecr_repository" "gitlab_ecr" {
    name = "gitlab-ecr"
    image_tag_mutability = "MUTABLE"

    encryption_configuration {
        encryption_type = "KMS"
        kms_key         = aws_kms_key.key_gitlab_db.arn
    }
}

resource "docker_image" "gitlab-14-k8s" {
  name = "gitlab/gitlab-ce:14.1.0-ce.0"
}







data "template_file" "gitlab_rb_template" {
  template = file("gitlab.rb")
  vars = {
    gitaly_client_token    = random_password.gitaly_client_auth_token.result
    gitaly_server_token    = random_password.gitaly_server_auth_token.result
    postgress_disable      = false
    redis_disable          = false
    nginx_disable          = false
    puma_disable           = false
    sidekiq_disable        = false
    workhorse_disable      = false
    grafana_disable        = false
    gitlabexporter_disable = false
    alertmanager_disable   = false
    prometheus_disable     = false
    automigrate_disable    = false
    tls_listen_address     = "0.0.0.0:9999"
    tls_cert_path          = "example.com"
    tls_key_path           = "example.com"
    ruby_workers_count     = "4"
    maintenance_start_hour = "4"
    maintenance_start_min  = "0"
    maintenance_duration   = "30m"
    redis_host             = data.terraform_remote_state.main_tf.outputs.gitlab_db_redis_endpoint
    redis_port             = data.terraform_remote_state.main_tf.outputs.gitlab_db_redis_port
    rails_db_adapter       = "postgresql"
    rails_db_encoding      = "unicode"
    rails_db_host          = data.terraform_remote_state.main_tf.outputs.gitlab_db_redis_endpoint
    rails_db_port          = data.terraform_remote_state.main_tf.outputs.gitlab_db_redis_port
    rails_db_password      = "temp_password_for_testing_dont_really_put_stuff_here"

    internal_api_url = "https://gitlab.example.com"
    external_url     = "https://gitlab.example.com"
  }
}

resource "random_password" "gitaly_server_auth_token" {
  length  = 25
  lower   = true
  number  = true
  upper   = true
  special = true
}

resource "random_password" "gitaly_client_auth_token" {
  length  = 25
  lower   = true
  number  = true
  upper   = true
  special = true
}


