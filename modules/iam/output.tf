# modules/iam/output.tf

output "role_arn" {
  description = "ARN of the IAM role created"
  value       = aws_iam_role.this.arn
}

output "policy_arn" {
  description = "ARN of the IAM policy created"
  value       = aws_iam_policy.this.arn
}
