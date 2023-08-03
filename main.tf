terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  # Nearby and surprisingly cheaper EC2 rates from a quick look
  region = "eu-north-1"
}


data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "CreateEC2Istances" {
  name = "CreateEC2Istances"
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ec2:Describe*",
            "ec2:RunInstances",
            "ec2:CreateKeyPair"
          ],
          Effect = "Allow"
          Resource = ["*"]
        }
      ]
    }
  )
}

resource "aws_iam_role" "DevDesktopBooterExecutionRole" {
  name = "DevDesktopBooterExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  }) 
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRoleAtch" {
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
  role = aws_iam_role.LambdaExecutionRole.name
}

resource "aws_iam_role_policy_attachment" "CreateEC2IstancesAtch" {
  policy_arn = aws_iam_policy.CreateEC2Istances.arn
  role = aws_iam_role.LambdaExecutionRole.name
}


resource "aws_lambda_function" "example" {
  function_name = "DevDesktopBooter"
  role = aws_iam_role.DevDesktopBooterExecutionRole.arn
}
