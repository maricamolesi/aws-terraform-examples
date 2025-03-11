# Package the Lambda function
data "archive_file" "lambda_function_file" {
  type        = "zip"
  source_dir  = "${var.subfolder}${var.function_name}"
  output_path = "./lambda_files/${var.function_name}.zip"
}

# Upload the Lambda code to S3
resource "aws_s3_object" "lambda_code" {
  bucket = var.bucket
  key    = "${var.function_name}.zip"
  source = data.archive_file.lambda_function_file.output_path

  etag = filemd5(data.archive_file.lambda_function_file.output_path)
}

# Create the IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name               = "lambda-${var.function_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

# Attach the IAM policy to the Lambda role
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda-${var.function_name}-policy"
  description = "Lambda ${var.function_name} execution policy"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = flatten([
      for statement in var.lambda_policy_statements : {
        Action   = statement.actions
        Resource = statement.resources
        Effect   = "Allow"
      }
    ])
  })
}

# Attach the policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Create the Lambda function
resource "aws_lambda_function" "lambda_function" {
  function_name         = var.function_name
  runtime               = var.runtime
  handler               = var.handler
  role                  = aws_iam_role.lambda_role.arn
  s3_bucket             = aws_s3_object.lambda_code.bucket
  s3_key                = aws_s3_object.lambda_code.key
  source_code_hash      = aws_s3_object.lambda_code.etag
  timeout               = var.timeout
  memory_size           = var.memory_size
  layers                = var.layers
  tags                  = {
    Name = var.function_name
  }

  environment {
    variables = var.environment_variables
  }

  vpc_config {
    subnet_ids          = var.subnet_ids
    security_group_ids  = var.security_group_ids
  }
}

# Permission for Secrets Manager to invoke the Lambda function
resource "aws_lambda_permission" "allow_secrets_manager" {
  count = var.allow_secrets_manager ? 1 : 0
  statement_id  = "AllowExecutionFromSecretManager"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "secretsmanager.amazonaws.com"
}

# Permission for EventBridge to invoke the Lambda function
resource "aws_lambda_permission" "allow_eventbridge" {
  count = var.create_eventbridge ? 1 : 0
  statement_id  = "AllowEventBridgeInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
}

# Create the EventBridge rule if the variable is true
resource "aws_cloudwatch_event_rule" "event_rule" {
  count               = var.create_eventbridge ? 1 : 0
  name                = "trigger-lambda-${var.function_name}"
  schedule_expression = var.eventbridge_schedule
}

# Create the EventBridge target if the variable is true
resource "aws_cloudwatch_event_target" "event_target" {
  count = var.create_eventbridge ? 1 : 0
  rule  = aws_cloudwatch_event_rule.event_rule[0].name
  arn   = aws_lambda_function.lambda_function.arn
}
