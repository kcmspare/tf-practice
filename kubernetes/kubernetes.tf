resource "kubernetes_namespace" "gitlab_kubernetes_namespace" {
  metadata {
    name = "gitlab"

    labels = {
      terraform = "true-github"
      use       = "Kanchimoe-Gitlab_on_AWS-K8S"
    }
  }
}

resource "kubernetes_deployment" "k8s_gitlab_deployment_appserver" {
  metadata {
    labels = {
      use       = "kanchimoe-gitlab_on_aws-k8s_appserver"
      terraform = "true-github"
    }
    name      = "gitlab-k8s-deployment-appserver"
    namespace = kubernetes_namespace.gitlab_kubernetes_namespace.metadata.0.name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        use = "kanchimoe-gitlab_on_aws-k8s_appserver"
      }
    }

    template {
      metadata {
        labels = {
          use = "kanchimoe-gitlab_on_aws-k8s_appserver"
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

resource "kubernetes_service" "k8s_gitlab_service_main_appserver" {
  metadata {
    name      = "gitlab-k8s-service-main-appserver"
    namespace = kubernetes_namespace.gitlab_kubernetes_namespace.metadata.0.name
  }

  spec {
    selector = {
      use = "kanchimoe-gitlab_on_aws-k8s_appserver"
    }

    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "NodePort"
  }

  depends_on = [kubernetes_deployment.k8s_gitlab_deployment_appserver]
}