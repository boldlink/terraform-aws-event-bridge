data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.${local.dns_suffix}"]
    }

    resources = ["arn:${local.partition}:sns:${local.region}:${local.account_id}:${local.topic_name}"]
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}
