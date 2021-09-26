resource "aws_ecr_repository" "gitlab_ecr" {
    name = "gitlab-ecr"
    image_tag_mutability = "MUTABLE"

    encryption_configuration {
        encryption_type = "KMS"
        kms_key         = aws_kms_key.key_gitlab_db.arn
    }
}

resource "docker_image" "kcm-docker-image" {
  name = "docker-name-here"
  build {
    path = "${path.cwd}/src"
    dockerfile = "dockerfile"
  }
}

resource "docker_registry_image" "kcm-docker-image" {
  name = "kcm-gitlab-d"

  build {
    context = "/${"src"}"
    dockerfile = "dockerfile"

    auth_config {
      host_name = aws_ecr_repository.gitlab_ecr.repository_url
      auth = data.aws_ecr_authorization_token.gitlab-docker-authtoken.authorization_token
      #identity_token 
      password = data.aws_ecr_authorization_token.gitlab-docker-authtoken.password
      #registry_token 
      server_address = data.aws_ecr_authorization_token.gitlab-docker-authtoken.proxy_endpoint
      user_name = data.aws_ecr_authorization_token.gitlab-docker-authtoken.user_name
    }
  }
} 

data "aws_ecr_authorization_token" "gitlab-docker-authtoken" {
}

data "template_file" "gitlab_rb_template" {
  template = file("src/gitlab.rb")
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
    redis_host             = aws_rds_cluster.DB_gitlab.endpoint
    redis_port             = aws_rds_cluster.DB_gitlab.port
    rails_db_adapter       = "postgresql"
    rails_db_encoding      = "unicode"
    rails_db_host          = aws_rds_cluster.DB_gitlab.endpoint
    rails_db_port          = aws_rds_cluster.DB_gitlab.port
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


