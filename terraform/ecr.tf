resource "aws_ecr_repository" "login-systems" {
  name                 = "login-systems"
  image_scanning_configuration {
    scan_on_push = true
  }
}
