data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "ssm_lifecycle_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.${local.dns_suffix}"]
    }
  }
}

data "aws_iam_policy_document" "ssm_lifecycle" {
  statement {
    effect    = "Allow"
    actions   = ["ssm:SendCommand"]
    resources = ["arn:${local.partition}:ec2:${local.region}:${local.account_id}:instance/*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/Environment"
      values   = ["*"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["ssm:SendCommand"]
    resources = [aws_ssm_document.stop_instance.arn]
  }
}
