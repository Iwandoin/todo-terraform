#Define keys and region
provider "aws" {
access_key = ""
secret_key = ""
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
