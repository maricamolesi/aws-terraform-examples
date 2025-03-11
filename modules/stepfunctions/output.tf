# modules/stepfunctions/outputs.tf

output "state_machine_arn" {
  description = "ARN of the created Step Function."
  value       = aws_sfn_state_machine.this.arn
}

output "role_arn" {
  description = "ARN of the IAM role associated with the Step Function."
  value       = aws_sfn_state_machine.this.role_arn
}
