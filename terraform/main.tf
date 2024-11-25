provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "meu-unico-bucket-s3"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_lambda_function" "my_lambda_function" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_execution_role.arn
  s3_bucket     = aws_s3_bucket.lambda_code_bucket.id
  s3_key        = "lambda.zip"
  runtime       = "nodejs20.x"
  handler       = "index.handler"
  timeout       = 15

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/my_lambda_function"
  retention_in_days = 14

  lifecycle {
    prevent_destroy = true
  }
}
