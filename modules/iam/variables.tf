# modules/iam/variables.tf

variable "assume_role_template" {
  description = "Path to the assume role policy template"
  type        = string
}

variable "role_name" {
  description = "Name of the IAM Role"
  type        = string
}

variable "policy_template" {
  description = "Path to the policy template"
  type        = string
}

variable "policy_vars" {
  description = "Variables for the IAM Policy"
  type        = map(string)
}

variable "policy_name" {
  description = "Name of the IAM Policy"
  type        = string
}
