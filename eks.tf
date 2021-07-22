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
