provider "aws" {
  region = var.region
  default_tags {  
    tags = merge(var.default_tags,
                {App  = var.app_tag})
    }
}

#------------LAMBDAS----------------
module "lambda" {
  source                   = "./modules/lambda"

  function_name            = var.function_name
  runtime                  = var.runtime
  timeout                  = var.timeout
  memory_size              = var.memory_size
  layers                   = var.layers

  lambda_policy_statements = var.lambda_policy_statements

  environment_variables    = var.environment_variables

  subnet_ids               = var.subnet_ids
  security_group_ids       = var.security_group_ids

  allow_secrets_manager    = var.allow_secrets_manager
  
  create_eventbridge       = var.create_eventbridge
  eventbridge_schedule     = var.eventbridge_schedule
}

#------------STEP FUNCTION----------------
module "stepfunction" {
  source = "./modules/stepfunctions"

  state_machine_name      = var.state_machine_name

  enable_eventbridge      = var.enable_eventbridge
  schedule_expression     = var.schedule_expression
}
