# modules/stepfunctionss/variables.tf

variable "region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "sa-east-1"
}

variable "state_machine_name" {
  description = "The name of the state machine."
  type        = string
}

variable "state_machine_template" {
  description = "The path to the state machine template file."
  type        = string
  default     = "./state_machine.json"
}

variable "enable_eventbridge" {
  description = "Flag to enable or disable EventBridge."
  type        = bool
  default     = false
}

variable "schedule_expression" {
  description = "The schedule expression for EventBridge (e.g., cron or rate)."
  type        = string
  default     = ""
}
