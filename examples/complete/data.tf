data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_organizations_organization" "currrent" {}

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


## task definition
data "aws_ecs_task_definition" "main" {
  task_definition = "${var.supporting_resources_name}-task-definition"
}

data "aws_security_group" "main" {
  name = "${var.supporting_resources_name}-security-group"
}

data "aws_vpc" "supporting" {
  filter {
    name   = "tag:Name"
    values = [var.supporting_resources_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${var.supporting_resources_name}*.pri.*"]
  }
}

data "aws_ecs_cluster" "ecs" {
  cluster_name = var.supporting_resources_name
}

## ecs target policy doc
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ecs_events_run_task_with_any_role" {
  #checkov:skip=CKV_AWS_109:"Ensure IAM policies does not allow permissions management / resource exposure without constraints"
  #checkov:skip=CKV_AWS_356:"Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = [replace(local.task_definition_arn, "/:\\d+$/", ":*")]
  }
}

## others
data "aws_iam_policy_document" "assume_others" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "redshift.amazonaws.com",
        "batch.amazonaws.com",
        "sqs.amazonaws.com"
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}
