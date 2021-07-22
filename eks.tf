# EKS

resource "aws_eks_cluster" "EKS_cluster" {
  name      = "Gitlab EKS Cluster"
  role_arn  = x

  vpc_config {
    subnet_ids = [
      module.vpc.private_subnets
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.PolicyAttachment_Gitlab_EKS_Cluster,
    aws_iam_role_policy_attachment.PolicyAttachment_Gitlab_EKS_Pods
  ]
}