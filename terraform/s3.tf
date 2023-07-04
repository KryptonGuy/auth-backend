resource "aws_s3_bucket" "login_systems_bucket" {
  bucket = "login-systems-bucket-${data.aws_caller_identity.current.account_id}"
}