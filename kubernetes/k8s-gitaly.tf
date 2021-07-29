resource "kubernetes_deployment" "k8s_gitlab_deployment_gitaly" {
  metadata {
    labels = {
      use       = "Kanchimoe-Gitlab_on_AWS-K8S-gitaly"
      terraform = "true-github"
    }
    name      = "gitlab-k8s-deployment-gitaly"
    namespace = kubernetes_namespace.gitlab_kubernetes_namespace.metadata.0.name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        use = "Kanchimoe-Gitlab_on_AWS-K8S-gitaly"
      }
    }
    
    template {
      metadata {
        labels = {
          use = ""
        }
      }

      spec {
        container {
          image = "gitlab/gitlab-ce:14.1.0-ce.0"
          name  = "Gitlab CE 14.1.0 docker image"
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
      use = "Kanchimoe-Gitlab_on_AWS-K8S-gitaly"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "NodePort"
  }

  depends_on = [kubernetes_deployment.k8s_gitlab_deployment]
}
