provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ec2.amazonaws.com", "codebuild.amazonaws.com", "codepipeline.amazonaws.com"]
        }
      },
    ]
  })

}

resource "aws_iam_role_policy" "eks-describe-policy" {
  name = "eks-describe-policy"
  role = aws_iam_role.codebuild_role.id


  policy = jsonencode({ 
        "Version": "2012-10-17"
        "Statement": [ 
            { 
                "Effect": "Allow" 
                "Action": "eks:Describe*" 
                "Resource": "*" 
            },
        ]
    })
}

resource "aws_iam_policy_attachment" "AmazonEC2ContainerRegistryFullAccess" {
  name       = "AmazonEC2ContainerRegistryFullAccess"
  roles      = [aws_iam_role.codebuild_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_policy_attachment" "CloudWatchLogsFullAccess" {
  name       = "CloudWatchLogsFullAccess"
  roles      = [aws_iam_role.codebuild_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_policy_attachment" "AWSCodeBuildAdminAccess" {
  name       = "AWSCodeBuildAdminAccess"
  roles      = [aws_iam_role.codebuild_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"
}

resource "aws_iam_policy_attachment" "AWSCodeCommitFullAccess" {
  name       = "AWSCodeCommitFullAccess"
  roles      = [aws_iam_role.codebuild_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}

resource "aws_iam_policy_attachment" "AmazonS3FullAccess" {
  name       = "AmazonS3FullAccess"
  roles      = [aws_iam_role.codebuild_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
