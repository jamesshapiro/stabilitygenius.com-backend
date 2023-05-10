data "aws_iam_policy_document" "allow_access_to_cloudfront_oai" {
  statement {
    principals {
      type        = "CanonicalUser"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_oai.s3_canonical_user_id]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}