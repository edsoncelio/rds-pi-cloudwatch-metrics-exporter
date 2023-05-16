data "archive_file" "lambda" {
  type        = "zip"
  source_file      = "${path.module}/function/lambda_function.py"
  output_path = "lambda_function.zip"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "aurora-monitoring-grafana-pi"

  tags = {
    Name      = "aurora-monitoring-grafana-pi"
    CreatedBy = "Terraform"
  }
}

resource "aws_lambda_function" "lambda-function" {
  filename      = "lambda_function.zip"
  function_name = "rds_pi_cloudwatch_metrics_exporter"
  role          = aws_iam_role.lambda-role.arn
  handler       = "lambda_function.lambda_handler"
  timeout       = 300

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.8"

  environment {
    variables = {
      TargetMetricNamespace = var.target_metric_namespace
    }
  }
}
