resource "aws_cloudwatch_event_rule" "event-rule" {
  name        = "every_10_minutes_rule"
  description = "trigger lambda every 10 minute"

  schedule_expression = "rate(10 minutes)"
}

resource "aws_cloudwatch_event_target" "target" {
  rule      = aws_cloudwatch_event_rule.event-rule.name
  target_id = "SendToLambda"
  arn       = aws_lambda_function.lambda-function.arn
}

