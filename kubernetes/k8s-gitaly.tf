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
