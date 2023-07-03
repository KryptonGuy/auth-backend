
resource "aws_codebuild_project" "build" {
  name = "login-system-build"
  description = "Builds the client files for the app environment."
  build_timeout = "5"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

   cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type = "LINUX_CONTAINER"
    privileged_mode = true

  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildspec.yaml"
  }
}