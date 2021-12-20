resource "aws_s3_bucket" "my-bucket" {
  bucket = var.bucket
}

resource "aws_s3_bucket_object" "my-object" {
  bucket = aws_s3_bucket.my-bucket.bucket
  key    = var.key
  source = var.file
}

