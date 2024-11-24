terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Reutilizando o Bucket S3 Existente
resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "meu-unico-bucket-s3"

  lifecycle {
    prevent_destroy = true
  }
}

# Reutilizando a IAM Role Existente
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"  # A mesma role que já existe

  # Política de confiança (assume_role_policy)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  lifecycle {
    prevent_destroy = true
  }
}


# Reutilizando a Função Lambda Existente
resource "aws_lambda_function" "my_lambda_function" {
  function_name = "my_lambda_function"  # Nome fixo para a função Lambda
  s3_bucket     = aws_s3_bucket.lambda_code_bucket.bucket
  s3_key        = "lambda.zip"
  handler       = "src/index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_execution_role.arn

  lifecycle {
    prevent_destroy = true
  }
}

# Reutilizando o CloudWatch Log Group Existente
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/my_lambda_function"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [name]
  }
}
