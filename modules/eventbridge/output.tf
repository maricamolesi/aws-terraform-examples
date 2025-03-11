# modules/eventbridge/output.tf

output "event_rule_arn" {
  description = "ARN of the CloudWatch Event rule"
  value       = aws_cloudwatch_event_rule.this.arn
}

output "event_rule_name" {
  description = "Name of the CloudWatch Event rule"
  value       = aws_cloudwatch_event_rule.this.name
}

output "event_target_id" {
  description = "ID of the CloudWatch Event target"
  value       = aws_cloudwatch_event_target.this.id
}
