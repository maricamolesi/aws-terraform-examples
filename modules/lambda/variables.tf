variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "subfolder" {
  description = "Name of the folder if the lambdas are separated into folders for different data sources"
  type        = string
  default     = "../lambdas/"
}

variable "bucket" {
  description = "Name of the S3 bucket to store the Lambda function code"
  type        = string
  default     = "lambdas-zip"
}

variable "lambda_policy_statements" {
  description = "List of IAM policy statements for the Lambda execution role"
  type        = list(object({
    actions   = list(string)
    resources = list(string)
  }))
  default = []
}

variable "runtime" {
  description = "Runtime of the Lambda function (e.g., python3.8)"
  type        = string
}

variable "handler" {
  description = "Name of the Lambda function handler"
  type        = string
  default     = "lambda_function.lambda_handler"
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

variable "layers" {
  description = "List of ARNs for the Lambda function layers"
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
  description = "Allow Secrets Manager to invoke the Lambda function"
  type        = bool
  default     = false
}

variable "create_eventbridge" {
  description = "Create EventBridge rules for the Lambda function"
  type        = bool
  default     = false
}

variable "eventbridge_schedule" {
  description = "Schedule expression for EventBridge"
  type        = string
  default     = ""
}
