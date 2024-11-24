output "lambda_arn" {
  value = aws_lambda_function.my_lambda_function.arn
}

output "bucket_name" {
  value = aws_s3_bucket.lambda_code_bucket.bucket
}

output "lambda_function_name" {
  value = aws_lambda_function.my_lambda_function.function_name
}