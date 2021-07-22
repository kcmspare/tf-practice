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