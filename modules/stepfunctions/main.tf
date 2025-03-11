data "aws_caller_identity" "current" {}

locals {
    region     = var.region                      
    account_id = data.aws_caller_identity.current.account_id 
}

# Creates an IAM role for the Step Function
resource "aws_iam_role" "step_function_role" {
  name = "stepfunction-${var.state_machine_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "states.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Creates an IAM policy for the Step Function
resource "aws_iam_policy" "step_function_policy" {
  name = "stepfunction-${var.state_machine_name}-policy" 
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = [
          "arn:aws:lambda:${var.region}:${local.account_id}:function:*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
                "logs:CreateLogDelivery",
                "logs:CreateLogStream",
                "logs:GetLogDelivery",
                "logs:UpdateLogDelivery",
                "logs:DeleteLogDelivery",
                "logs:ListLogDeliveries",
                "logs:PutLogEvents",
                "logs:PutResourcePolicy",
                "logs:DescribeResourcePolicies",
                "logs:DescribeLogGroups"
            ],
        Resource = "*"
      }
    ]
  })
}

# Attaches the policy to the Step Function role
resource "aws_iam_role_policy_attachment" "step_function_policy_attachment" {
  role       = aws_iam_role.step_function_role.name
  policy_arn = aws_iam_policy.step_function_policy.arn
}

# Loads the state machine template
data "template_file" "state_machine_definition" {
  template = file(var.state_machine_template)
  vars     = {
    region     = var.region
    account_id = data.aws_caller_identity.current.account_id
  }
}

# Creates a CloudWatch log group for the Step Function
resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/vendedlogs/states/${var.state_machine_name}"
}

# Creates the state machine (Step Function)
resource "aws_sfn_state_machine" "this" {
  name       = var.state_machine_name
  role_arn   = aws_iam_role.step_function_role.arn 
  definition = data.template_file.state_machine_definition.rendered
  tags       = {
    Name = var.state_machine_name
  }

  # Step Function logging configuration
  logging_configuration {
    include_execution_data = true
    level                  = "ALL"
    log_destination        = "${aws_cloudwatch_log_group.this.arn}:*"
  }
}

# Creates an IAM role for EventBridge
resource "aws_iam_role" "eventbridge_role" {
  count = var.enable_eventbridge ? 1 : 0
  name  = "eventbridge-stepfunction-${var.state_machine_name}-role" 
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "events.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Creates an IAM policy for EventBridge
resource "aws_iam_policy" "eventbridge_policy" {
  count = var.enable_eventbridge ? 1 : 0
  name  = "eventbridge-stepfunction-${var.state_machine_name}-policy"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "states:StartExecution"
        ],
        Resource = "arn:aws:states:${var.region}:${local.account_id}:stateMachine:${var.state_machine_name}"  # ARN of the Step Function
      }
    ]
  })
}

# Attaches the policy to the EventBridge role
resource "aws_iam_role_policy_attachment" "eventbridge_policy_attachment" {
  count = var.enable_eventbridge ? 1 : 0
  role  = aws_iam_role.eventbridge_role[0].name
  policy_arn = aws_iam_policy.eventbridge_policy[0].arn
}

# Creates the CloudWatch Event rule to schedule the Step Function execution
resource "aws_cloudwatch_event_rule" "eventbridge_rule" {
  count               = var.enable_eventbridge ? 1 : 0
  name                = "trigger-stepfunction-${var.state_machine_name}"
  description         = "Trigger ${var.schedule_expression} for the project ${var.state_machine_name}"
  schedule_expression = var.schedule_expression
}

# Creates the CloudWatch Event target that triggers the Step Function
resource "aws_cloudwatch_event_target" "eventbridge_target" {
  count     = var.enable_eventbridge ? 1 : 0
  rule      = aws_cloudwatch_event_rule.eventbridge_rule[0].name
  arn       = aws_sfn_state_machine.this.arn
  role_arn  = aws_iam_role.eventbridge_role[0].arn
}
