terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Bucket S3 para armazenamento do código da Lambda
resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "meu-unico-bucket-s3" # Nome fixo para reutilizar o bucket existente
}

# IAM Role para execução da Lambda
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
      },
    ]
  })
}

# Função Lambda
resource "aws_lambda_function" "my_lambda_function" {
  function_name = "my_lambda_function"
  s3_bucket     = aws_s3_bucket.lambda_code_bucket.bucket
  s3_key        = "lambda.zip"
  handler       = "src/index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_execution_role.arn

  # Configuração de variáveis de ambiente (opcional)
  environment {
    variables = {
      ENV = "production"
    }
  }
}

# Grupo de logs para a Lambda
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/my_lambda_function"
  retention_in_days = 14
}
