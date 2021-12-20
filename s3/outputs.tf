output "bucket" {
  value = aws_s3_bucket.my-bucket.bucket
}
output "key" {
  value = aws_s3_bucket_object.my-object.key
}