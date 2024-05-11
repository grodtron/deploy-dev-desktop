terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.48"
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
            "ec2:CreateKeyPair",
            "iam:PassRole",
          ],
          Effect = "Allow"
          Resource = ["*"]
        }
      ]
    }
  )
}

# Get latest Ubuntu Linux Disco 20.04 AMI
data "aws_ami" "ubuntu-linux-2204" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/16"
}

resource "aws_launch_template" "DevDesktopTemplate" {
  name = "DevDesktopTemplate"

  image_id = data.aws_ami.ubuntu-linux-2204.id
  update_default_version = true

  iam_instance_profile {
    arn = "arn:aws:iam::911866154296:instance-profile/PersonalDevDesktopRole"
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 30
      delete_on_termination = true
      volume_type = "gp2"
    }
  }

  network_interfaces {
    subnet_id = aws_subnet.main.id
    delete_on_termination = true
    associate_public_ip_address = true
  }


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
  role = aws_iam_role.DevDesktopBooterExecutionRole.name
}

resource "aws_iam_role_policy_attachment" "CreateEC2IstancesAtch" {
  policy_arn = aws_iam_policy.CreateEC2Istances.arn
  role = aws_iam_role.DevDesktopBooterExecutionRole.name
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "deploy-dev-desktop--lambda-deployment"  # Update with your desired bucket name
}


resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "dev-desktop-booter.zip"
  source = "bazel-bin/src/deployment_archive.zip"
  etag = filemd5("bazel-bin/src/deployment_archive.zip")
}


resource "aws_lambda_function" "DevDesktopBooterLambda" {
  function_name = "DevDesktopBooter"
  role = aws_iam_role.DevDesktopBooterExecutionRole.arn
  handler = "src.main.lambda_handler"
  runtime = "python3.10"
  s3_bucket = aws_s3_object.lambda_zip.bucket
  s3_key = aws_s3_object.lambda_zip.key
  source_code_hash = filemd5("bazel-bin/src/deployment_archive.zip")
  timeout = 900
  memory_size = 512

  environment {
    variables = {
      LAUNCH_TEMPLATE_NAME = aws_launch_template.DevDesktopTemplate.name
    }
  }
}
