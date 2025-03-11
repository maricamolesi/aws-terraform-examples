variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "sa-east-1"
}

variable "default_tags" {
  description = "Default tags for the resources."
  type        = map(string)
  default     = {
                    AccessControl   = "Data",
                    Availability    = "Full",
                    BusinessUnit    = "Data Science",
                    Env             = "Production",
                    Product         = "DataLake",
                }
}

variable "app_tag" {
  description = "Tag indicating the application related to the project."
  type        = string
}

#------------LAMBDAS----------------
variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "runtime" {
  description = "Lambda function runtime environment"
  type        = string
}

variable "timeout" {
  description = "Timeout for the Lambda function in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Memory size for the Lambda function in MB"
  type        = number
  default     = 128
}

variable "lambda_policy_statements" {
  description = "List of IAM policy statements for the Lambda execution role"
  type        = list(object({
    actions   = list(string)
    resources = list(string)
  }))
  default = []
}

variable "layers" {
  description = "List of ARNs of the layers for the Lambda function"
  type        = list(string)
  default     = []
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Lambda function"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "List of security group IDs for the Lambda function"
  type        = list(string)
  default     = []
}

variable "allow_secrets_manager" {
  description = "Allow the Secrets Manager to invoke the Lambda function"
  type        = bool
  default     = false
}

variable "create_eventbridge" {
  description = "Create EventBridge rules for the Lambda function"
  type        = bool
  default     = false
}

variable "eventbridge_schedule" {
  description = "EventBridge schedule expression"
  type        = string
  default     = ""
}

#------------STEP FUNCTION----------------
variable "state_machine_name" {
  description = "Step Function state machine name."
  type        = string
}

variable "enable_eventbridge" {
  description = "Flag to enable or disable EventBridge."
  type        = bool
  default     = false
}

variable "schedule_expression" {
  description = "Schedule expression for EventBridge."
  type        = string
}
