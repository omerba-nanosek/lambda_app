provider "aws" {
  region = "us-east-1"
}

module "s3" {
  source = "./s3"
  bucket = "omerba123"
  file   = "./app.zip"
  key    = "app.zip"
}

module "lambda" {
  source = "./lambda"
  name   = "HelloWorldFunction"
  bucket = module.s3.bucket
  key    = module.s3.key
}
