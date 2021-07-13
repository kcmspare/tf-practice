# S3 buckets

resource "aws_s3_bucket" "gl_registry" {
  bucket = "gl-registry"
  acl    = "private"
}

resource "aws_s3_bucket" "gl_artifacts" {
  bucket = "gl-artifacts"
  acl    = "private"
}

resource "aws_s3_bucket" "gl_backup" {
  bucket = "gl-backup"
  acl    = "private"
}

resource "aws_s3_bucket" "gl_lfs" {
  bucket = "gl-lfs"
  acl    = "private"
}

resource "aws_s3_bucket" "gl_uploads" {
  bucket = "gl-uploads"
  acl    = "private"
}

resource "aws_s3_bucket" "gl_mr_diffs" {
  bucket = "gl-mr_diffs"
  acl    = "private"
}