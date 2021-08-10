resource "kubernetes_deployment" "k8s_gitlab_coredns" {
  metadata {
    labels = {
      "eks.amazonaws.com/component" = "coredns"
      k8s-app                       = "kube-dns"
    }
    name      = "coredns"
    namespace = "kube-system"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        "eks.amazonaws.com/component" = "coredns"
        "k8s-app"                     = "kube-dns"
      }
    }

    template {
      metadata {

        labels = {
          "eks.amazonaws.com/component" = "coredns"
          "k8s-app"                     = "kube-dns"
        }
      }

      spec {
        container {
          args = [
            "-conf",
            "/etc/coredns/Corefile"
          ]
          image = "602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/coredns:v1.8.3-eksbuild.1"
          name  = "coredns"

          liveness_probe {
            failure_threshold     = 5
            initial_delay_seconds = 60
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 5

            http_get {
              path   = "/health"
              port   = "8080"
              scheme = "HTTP"
            }
          }

          port {
            container_port = 53
            name           = "dns"
            protocol       = "UDP"
          }
          port {
            container_port = 53
            name           = "dns-tcp"
            protocol       = "TCP"
          }
          port {
            container_port = 9153
            name           = "metrics"
            protocol       = "TCP"
          }

          readiness_probe {
            failure_threshold     = 3
            initial_delay_seconds = 0
            period_seconds        = 10
            success_threshold     = 1
            timeout_seconds       = 1

            http_get {
              path   = "/health"
              port   = "8080"
              scheme = "HTTP"
            }
          }

          security_context {
            allow_privilege_escalation = false
            privileged                 = false
            read_only_root_filesystem  = true
            run_as_non_root            = false

            capabilities {
              add = [
                "NET_BIND_SERVICE",
              ]
              drop = [
                "all"
              ]
            }
          }

          volume_mount {
            mount_path = "/etc/coredns"
            name       = "config-volume"
            read_only  = true
          }
          volume_mount {
            mount_path = "/tmp"
            name       = "tmp"
            read_only  = false
          }

        }
        automount_service_account_token = true
        dns_policy                      = "Default"
        enable_service_links            = false
        priority_class_name             = "system-cluster-critical"

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "beta.kubernetes.io/os"
                  operator = "In"
                  values = [
                    "linux",
                  ]
                }

                match_expressions {
                  key      = "beta.kubernetes.io/arch"
                  operator = "In"
                  values = [
                    "amd64",
                    "arm64",
                  ]
                }
              }
            }
          }
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 100

              pod_affinity_term {
                namespaces   = []
                topology_key = "kubernetes.io/hostname"

                label_selector {
                  match_labels = {}

                  match_expressions {
                    key      = "k8s-app"
                    operator = "In"
                    values = [
                      "kube-dns",
                    ]
                  }
                }
              }
            }
          }



        }

        toleration {
          effect = "NoSchedule"
          key    = "node-role.kubernetes.io/master"
        }
        toleration {
          key      = "CriticalAddonsOnly"
          operator = "Exists"
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.gitlab_kubernetes_namespace]
}