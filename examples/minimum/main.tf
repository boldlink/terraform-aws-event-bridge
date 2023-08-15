module "sns" {
  #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
  source  = "boldlink/sns/aws"
  version = "1.1.1"
  name    = local.topic_name
  policy  = data.aws_iam_policy_document.sns_topic_policy.json
  tags    = local.tags
}

module "minumum_example" {
  source        = "../.."
  name          = local.name
  event_pattern = local.event_pattern
  description   = "Capture each AWS Console Sign In"
  tags          = local.tags
  target_id     = "SendToSNS"
  arn           = module.sns.arn
}
