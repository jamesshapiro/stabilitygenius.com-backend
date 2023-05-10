resource "aws_s3_bucket" "this" {
  bucket = "stabilitygenius.com"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.allow_access_to_cloudfront_oai.json
}