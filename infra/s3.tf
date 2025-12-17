# ============================================
# S3 Bucket Configuration
# Storage for backups, assets, and artifacts
# ============================================

# ============================================
# Random suffix for bucket name uniqueness
# ============================================
resource "random_id" "bucket_suffix" {
  count       = var.create_s3_bucket && var.s3_bucket_name == "" ? 1 : 0
  byte_length = 4
}

locals {
  bucket_name = var.s3_bucket_name != "" ? var.s3_bucket_name : (
    var.create_s3_bucket ? "${var.project_name}-storage-${var.environment}-${random_id.bucket_suffix[0].hex}" : ""
  )
}

# ============================================
# S3 Bucket
# ============================================
resource "aws_s3_bucket" "main" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = local.bucket_name

  tags = {
    Name = local.bucket_name
  }
}

# ============================================
# S3 Bucket Versioning
# ============================================
resource "aws_s3_bucket_versioning" "main" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.main[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

# ============================================
# S3 Bucket Server-Side Encryption
# ============================================
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.main[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# ============================================
# S3 Bucket Public Access Block
# ============================================
resource "aws_s3_bucket_public_access_block" "main" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.main[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ============================================
# S3 Bucket Lifecycle Rules
# ============================================
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.main[0].id

  rule {
    id     = "cleanup-old-versions"
    status = "Enabled"

    filter {
      prefix = ""
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    noncurrent_version_transition {
      noncurrent_days = 7
      storage_class   = "GLACIER"
    }
  }

  rule {
    id     = "cleanup-incomplete-uploads"
    status = "Enabled"

    filter {
      prefix = ""
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  rule {
    id     = "archive-old-backups"
    status = "Enabled"

    filter {
      prefix = "backups/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

# ============================================
# S3 Bucket Policy
# ============================================
resource "aws_s3_bucket_policy" "main" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.main[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnforceTLS"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.main[0].arn,
          "${aws_s3_bucket.main[0].arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# ============================================
# S3 Bucket for Backups Subfolder Structure
# ============================================
resource "aws_s3_object" "folders" {
  count = var.create_s3_bucket ? 3 : 0

  bucket = aws_s3_bucket.main[0].id
  key    = element(["backups/", "logs/", "artifacts/"], count.index)
  content_type = "application/x-directory"
}
