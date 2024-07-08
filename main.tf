#create an s3 bucket

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname

}

#Bucket Ownership controls

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#Bucket public access

resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#Bucket ACL

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership,
    aws_s3_bucket_public_access_block.bucket_public_access,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

#s3 object

resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"
  source = "index.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "styles" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "styles.css"
  source = "styles.css"
  acl    = "public-read"
  content_type = "text/css"
}

resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "error.html"
  source = "error.html"
  acl    = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "styles1" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "style_error.css"
  source = "style_error.css"
  acl    = "public-read"
  content_type = "text/css"
}


resource "aws_s3_object" "profile" {
    bucket = aws_s3_bucket.mybucket.id
    key = "profile.png"
    source = "profile.png"
    acl = "public-read"
  
}

#website configuration

resource "aws_s3_bucket_website_configuration" "conf" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.bucket_acl ]

  
  
}