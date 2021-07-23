resource "kubernetes_namespace" "gitlab_kubernetes_namespace" {
  metadata {
    name = "gitlab"

    labels = {
      terraform = "true-github"
      use       = "Kanchimoe-Gitlab_on_AWS-K8S"
    }
  }
}
