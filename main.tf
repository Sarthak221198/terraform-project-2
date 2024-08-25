resource "aws_s3_bucket" "my-bucket" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "S3-ownership" {
  bucket = aws_s3_bucket.my-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}  

resource "aws_s3_bucket_public_access_block" "S3-public-access" {
  bucket = aws_s3_bucket.my-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3-acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.S3-ownership,
    aws_s3_bucket_public_access_block.S3-public-access,
  ]

  bucket = aws_s3_bucket.my-bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  key    = "index.html"
  bucket = aws_s3_bucket.my-bucket.id
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"

}

resource "aws_s3_object" "error" {
  key    = "error.html"
  bucket = aws_s3_bucket.my-bucket.id
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"

}

resource "aws_s3_object" "profile" {
  key    = "profile.png"
  bucket = aws_s3_bucket.my-bucket.id
  source = "profile.png"
  acl = "public-read"

}

resource "aws_s3_bucket_website_configuration" "website-hosting" {
  bucket = aws_s3_bucket.my-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  depends_on = [ aws_s3_bucket_acl.s3-acl ]
}
