# S3 buckets

resource "aws_s3_bucket" "gl_registry" {
  bucket = "gl-registry-kcm"
  acl    = "private"
}

resource "aws_s3_bucket" "gl_artifacts" {
  bucket = "gl-artifacts-kcm"
  acl    = "private"
}

resource "aws_s3_bucket" "gl_backup" {
  bucket = "gl-backup-kcm"
  acl    = "private"
}

resource "aws_s3_bucket" "gl_lfs" {
  bucket = "gl-lfs-kcm"
  acl    = "private"
}

resource "aws_s3_bucket" "gl_uploads" {
  bucket = "gl-uploads-kcm"
  acl    = "private"
}

resource "aws_s3_bucket" "gl_mr_diffs" {
  bucket = "gl-mr-diffs-kcm"
  acl    = "private"
}