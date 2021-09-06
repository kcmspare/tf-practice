# EKS

resource "aws_eks_cluster" "EKS_cluster" {
  name      = "Gitlab-EKS-Cluster"
  role_arn  = aws_iam_role.Gitlab_EKS_cluster_role.arn

  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.PolicyAttachment_Gitlab_EKS_Cluster,
    aws_iam_role_policy_attachment.PolicyAttachment_Gitlab_EKS_Pods
  ]
}

## Outputs
output "gitlab_eks_cluster_endpoint" {
  value = aws_eks_cluster.EKS_cluster.endpoint
}

output "gitlab_eks_cluster_certificateauthority" {
  value = aws_eks_cluster.EKS_cluster.certificate_authority
}

output "gitlab_eks_cluster_id" {
  value = aws_eks_cluster.EKS_cluster.id
}

# Fargate

resource "aws_eks_fargate_profile" "Gitlab_EKS_fargate_profile" {
  cluster_name            = aws_eks_cluster.EKS_cluster.id
  fargate_profile_name    = "Gitlab_Fargate_Profile"
  pod_execution_role_arn  = aws_iam_role.Gitlab_fargate_profile.arn
  subnet_ids              = module.vpc.private_subnets

  selector {
    namespace = "gitlab"
  }
}

resource "aws_eks_fargate_profile" "Gitlab_coredns_fargateprofile" {
  cluster_name            = aws_eks_cluster.EKS_cluster.id
  fargate_profile_name    = "Gitlab_CoreDNS_Fargate_Profile"
  pod_execution_role_arn  = aws_iam_role.Gitlab_fargate_profile.arn
  subnet_ids              = module.vpc.private_subnets

  selector {
    namespace = "kube-system"

    labels = {
      "k8s-app"                     = "kube-dns"
      "eks.amazonaws.com/component" = "coredns"
    }
  }
}
