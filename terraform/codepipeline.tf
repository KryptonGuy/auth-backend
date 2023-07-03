resource "aws_codepipeline" "pipeline" {
  name     = "login-system-pipeline"
  role_arn = aws_iam_role.codebuild_role.arn

  artifact_store {
    location = "mybucket-999111"
    type     = "S3"
  }


  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        BranchName = "main"
        FullRepositoryId = "KryptonGuy/auth-backend"
        ConnectionArn = "arn:aws:codestar-connections:ap-south-1:734702322667:connection/7984063b-9799-43c2-9903-38d60276b95b"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["source"]
      output_artifacts = ["artifact"]
      version = "1"

      configuration = {
        ProjectName = "login-system-build"
      }
    }
  }

  depends_on = [module.eks]

}