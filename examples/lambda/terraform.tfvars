app_tag                 = "example"

#------------LAMBDAS----------------
function_name          = "my-lambda-function"
runtime                = "python3.8"
timeout                = 60
memory_size            = 128
layers                 = []

lambda_policy_statements = [
  {
    actions  = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:<region>:<account_id>:log-group:/aws/lambda/my-lambda-function:*"]
  }
]

environment_variables  = {
  "MY_ENV_VAR" = "some_value"
}

subnet_ids             = [""]
security_group_ids     = [""]

allow_secrets_manager  = true

create_eventbridge     = true
eventbridge_schedule   = "rate(5 minutes)"
