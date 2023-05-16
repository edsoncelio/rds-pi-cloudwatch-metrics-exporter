resource "aws_iam_role" "lambda-role" {
  name = "rdsPiCloudwatchMetricsExporter"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "policy-attachment" {

  for_each = toset([
    "arn:aws:iam::aws:policy/AWSLambda_ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonRDSPerformanceInsightsReadOnly",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ])

  role       = aws_iam_role.lambda-role.name
  policy_arn = each.value
}

resource "aws_lambda_permission" "allow-eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event-rule.arn
}