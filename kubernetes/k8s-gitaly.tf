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

          volume_mount {
            mount_path = "/etc/gitlab"
            name       = "gitlab-k8s-gitaly-configmap"
            read_only  = false
          }
        }
        volume {
          name = "gitlab-k8s-gitaly-configmap"
          config_map {
            name = kubernetes_config_map.k8s_gitlab_gitaly_configmap.metadata.0.name
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.gitlab_kubernetes_namespace,
  kubernetes_config_map.k8s_gitlab_gitaly_configmap]
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
  # will be removed soon
  metadata {
    name      = "gitlab-gitaly-configmap"
    namespace = kubernetes_namespace.gitlab_kubernetes_namespace.metadata.0.name
  }

  data = {
    "gitlab.rb"                = data.template_file.gitlab_rb_template.rendered
    "gitlab-secrets.json"      = file("src/gitlab-secrets.json")
    "initial_root_password"    = file("src/initial_root_password")
    "ssh_host_ecdsa_key"       = file("src/ssh_host_ecdsa_key")
    "ssh_host_ecdsa_key.pub"   = file("src/ssh_host_ecdsa_key.pub")
    "ssh_host_ed25519_key"     = file("src/ssh_host_ed25519_key")
    "ssh_host_ed25519_key.pub" = file("src/ssh_host_ed25519_key.pub")
    "ssh_host_rsa_key"         = file("src/ssh_host_rsa_key")
    "ssh_host_rsa_key.pub"     = file("src/ssh_host_rsa_key.pub")
  }
}

