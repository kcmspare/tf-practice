resource "kubernetes_deployment" "k8s_gitlab_deployment_gitaly" {
  metadata {
    labels = {
      use       = "kanchimoe-gitlab-on-aws-k8s-gitaly"
      terraform = "true-github"
    }
    name      = "gitlab-k8s-deployment-gitaly"
    namespace = kubernetes_namespace.gitlab_kubernetes_namespace.metadata.0.name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        use = "kanchimoe-gitlab-on-aws-k8s-gitaly"
      }
    }

    template {
      metadata {
        labels = {
          use = "kanchimoe-gitlab-on-aws-k8s-gitaly"
        }
      }

      spec {
        container {
          image = "gitlab/gitlab-ce:14.1.0-ce.0"
          name  = "gitlab-ce-14-1-0-dockerimage"


          resources {
            requests = {
              cpu    = "1"
              memory = "2Gi"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.gitlab_kubernetes_namespace]
}

resource "kubernetes_service" "k8s_gitlab_service_gitaly" {
  metadata {
    name      = "gitlab-k8s-service-gitaly"
    namespace = kubernetes_namespace.gitlab_kubernetes_namespace.metadata.0.name
  }

  spec {
    selector = {
      use = "kanchimoe-gitlab-on-aws-k8s-gitaly"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "NodePort"
  }

  depends_on = [kubernetes_deployment.k8s_gitlab_deployment_gitaly]
}

resource "kubernetes_config_map" "k8s_gitlab_gitaly_configmap" {
  metadata {
    name = "gitlab-gitaly-configmap"
  }

  data = {
    "gitlab.rb" = data.template_file.gitlab_rb_template.template
  }
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

    internal_api_url = "https://gitlab.example.com"
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
