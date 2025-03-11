# modules/eventbridge/main.tf

resource "aws_cloudwatch_event_rule" "this" {
  name                  = var.event_rule_name
  description           = var.event_rule_description
  schedule_expression   = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  arn       = var.target_arn
  role_arn  = var.role_arn
}
