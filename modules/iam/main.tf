# modules/stepfunction/main.tf

data "template_file" "assume_role" {
  template            = file(var.assume_role_template)
}

data "template_file" "policy" {
  template            = file(var.policy_template)
  vars                = var.policy_vars
}

resource "aws_iam_role" "this" {
  name                = var.role_name
  assume_role_policy  = data.template_file.assume_role.rendered
  tags                = {
                         Name = var.role_name
                        }
}

resource "aws_iam_policy" "this" {
  name                = var.policy_name
  policy              = data.template_file.policy.rendered
}

resource "aws_iam_role_policy_attachment" "this" {
  role                = aws_iam_role.this.name
  policy_arn          = aws_iam_policy.this.arn
}