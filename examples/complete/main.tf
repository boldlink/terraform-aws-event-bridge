### Note: In order to use this example against an instance, the following must be in place. The instance must:
### Have the AWS Systems Manager Agent (SSM Agent) installed and running.
### Have connectivity with Systems Manager endpoints using the SSM Agent (hence should have internet connectivity or use vpc endpoint).
### Have the correct AWS Identity and Access Management (IAM) role attached. (ensure `AmazonSSMManagedInstanceCore` policy is attached)
### Have connectivity to the instance metadata service.

resource "aws_ssm_document" "stop_instance" {
  name          = "stop_instance"
  document_type = "Command"
  content       = local.content
}

module "ssm_role" {
  source             = "boldlink/iam-role/aws"
  version            = "1.1.0"
  name               = "${local.name}-role"
  assume_role_policy = data.aws_iam_policy_document.ssm_lifecycle_trust.json
  description        = "Role to allow ssm stop instances"
  policies = {
    "${local.name}-policy" = {
      policy = data.aws_iam_policy_document.ssm_lifecycle.json
      tags   = local.tags
    }
  }
  tags = local.tags
}

module "complete_event_bridge_example" {
  source              = "../.."
  name                = local.name
  description         = "Event bridge rule to Stop instances nightly at 1900Hrs"
  schedule_expression = "cron(0 19 * * ? *)"
  target_id           = "StopInstances"
  arn                 = aws_ssm_document.stop_instance.arn
  target_role_arn     = module.ssm_role.arn
  tags                = local.tags
  run_command_targets = [
    {
      key    = "tag:Stop"
      values = ["true"]
    }
  ]
}
