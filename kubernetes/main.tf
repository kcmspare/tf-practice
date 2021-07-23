data "terraform_remote_state" "main_tf" {
  backend = "local"

  config = {
    path = "..\\main\\terraform.tfstate"
  }
}

data "aws_eks_cluster_auth" "gitlab_eks_cluster" {
  name = data.terraform_remote_state.main_tf.outputs.gitlab_eks_cluster_id
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.main_tf.outputs.gitlab_eks_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.main_tf.outputs.gitlab_eks_cluster_certificateauthority[0].data)
  token                  = data.aws_eks_cluster_auth.gitlab_eks_cluster.token
}
