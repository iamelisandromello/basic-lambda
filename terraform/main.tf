provider "aws" {
  region = var.region
}

resource "random_id" "lambda_suffix" {
  byte_length = 4
}

# Importando o bucket S3 existente
resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "meu-unico-bucket-s3"
  # Impede a recriação do bucket
  lifecycle {
    prevent_destroy = true
  }
}

# Importando a IAM Role existente
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"  # O nome da role que já existe

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

# Importando a função Lambda existente
resource "aws_lambda_function" "my_lambda_function" {
  function_name = "my_lambda_function"  # A mesma função Lambda existente
  s3_bucket     = aws_s3_bucket.lambda_code_bucket.bucket
  s3_key        = "lambda.zip"
  handler       = "src/index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_execution_role.arn

  lifecycle {
    prevent_destroy = true  # Impede a destruição acidental da função Lambda
  }
}

# Importando o grupo de logs do CloudWatch existente
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/my_lambda_function"
  
  lifecycle {
    prevent_destroy = true  # Impede a destruição acidental do grupo de logs
  }
}

