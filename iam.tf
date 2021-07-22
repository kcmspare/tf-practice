# IAM

resource "aws_iam_role" "Gitlab_EKS_cluster_role" {
    name               = "gitlab-eks-cluster"
    description        = "Gitlab EKS Cluster role"
    assume_role_policy = data.aws_iam_policy_document.AssumeRole_Gitlab_EKS_cluster.json
}

data "aws_iam_policy_document" "AssumeRole_Gitlab_EKS_cluster" {
    statement {
        actions = [
           "sts:AssumeRole" 
        ]
        principals {
            type = "Service"
            identifiers = ["eks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "PolicyAttachment_Gitlab_EKS_Cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.Gitlab_EKS_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "PolicyAttachment_Gitlab_EKS_Pods" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    role       = aws_iam_role.Gitlab_EKS_cluster_role.name
}