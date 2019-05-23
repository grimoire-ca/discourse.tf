resource "aws_iam_user" "discourse" {
  name = "discourse"

  tags = {
    Project = "discourse.tf"
  }
}

resource "aws_iam_access_key" "discourse" {
  user = aws_iam_user.discourse.name
}

resource "aws_s3_bucket" "attachments" {
  bucket = "lithobrake-club-attachments"

  provider = aws.s3
}

resource "aws_s3_bucket" "backups" {
  bucket = "lithobrake-club-backups"

  provider = aws.s3
}

resource "aws_iam_user_policy" "discourse_s3" {
  name = "discourse-s3"
  user = aws_iam_user.discourse.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
               "s3:List*",
               "s3:Get*",
               "s3:AbortMultipartUpload",
               "s3:DeleteObject",
               "s3:PutObject",
               "s3:PutObjectAcl",
               "s3:PutObjectVersionAcl",
               "s3:PutLifecycleConfiguration",
               "s3:CreateBucket",
               "s3:PutBucketCORS"
      ],
      "Resource": [
        "${aws_s3_bucket.attachments.arn}",
        "${aws_s3_bucket.attachments.arn}/*",
        "${aws_s3_bucket.backups.arn}",
        "${aws_s3_bucket.backups.arn}/*"
      ]
    },
    {
       "Effect": "Allow",
       "Action": [
           "s3:ListAllMyBuckets",
           "s3:HeadBucket"
       ],
       "Resource": "*"
    }
  ]
}
POLICY

}

output "access_key_id" {
  value = aws_iam_access_key.discourse.id
}

output "secret_access_key" {
  value = aws_iam_access_key.discourse.secret
}

