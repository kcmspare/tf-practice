resource "aws_ecr_repository" "gitlab_ecr" {
    name = "gitlab-ecr"
    image_tag_mutability = "MUTABLE"

    encryption_configuration {
        encryption_type = "KMS"
        kms_key         = aws_kms_key.key_gitlab_db.arn
    }
}

resource "docker_image" "gitlab-14-k8s" {
  name = "gitlab/gitlab-ce:14.1.0-ce.0"
}

