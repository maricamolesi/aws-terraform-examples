# modules/eventbridge/variables.tf

variable "event_rule_name" {
  description = "Name of the EventBridge rule"
  type        = string
}

variable "event_rule_description" {
  description = "Description of the EventBridge rule"
  type        = string
}

variable "schedule_expression" {
  description = "Schedule expression for the EventBridge rule"
  type        = string
}

variable "target_arn" {
  description = "ARN of the target that the EventBridge rule will invoke"
  type        = string
}

variable "role_arn" {
  description = "ARN of the role that EventBridge will use"
  type        = string
}
