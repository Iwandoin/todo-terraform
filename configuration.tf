#Define keys and region
provider "aws" {
access_key = "AKIAV5D7ZMYRR54AF4M4"
secret_key = "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"
region = "eu-central-1"
}
#Define s3 bucket
resource "aws_s3_bucket" "bucket1" {
bucket = "vyadro3"
acl = "private" # or can be "public-read"
tags = {
Name = "Bucket"
Environment = "Production"
}
}

output "s3" {
  value = aws_s3_bucket.bucket1.id
}