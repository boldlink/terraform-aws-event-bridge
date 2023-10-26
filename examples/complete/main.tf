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

###
module "extended_event_bridge_example" {
  source              = "../.."
  name                = local.name
  description         = "Extended Event bridge rule example"
  schedule_expression = "cron(0 19 * * ? *)"
  target_id           = "ExtendedTargets"
  arn                 = aws_ssm_document.stop_instance.arn
  target_role_arn     = module.ssm_role.arn
  tags                = local.tags

  # Run Command Targets
  run_command_targets = [
    {
      key    = "tag:Stop"
      values = ["true"]
    }
  ]

  # HTTP Target
  http_target = [
    {
      path_parameter_values = ["value1", "value2"],
      query_string_parameters = {
        "param1" = "value1",
        "param2" = "value2"
      },
      header_parameters = {
        "header1" = "value1",
        "header2" = "value2"
      }
    }
  ]

  # SQS Target
  sqs_target = [
    {
      message_group_id = "example-group-id"
    }
  ]

  # Batch Target
  batch_target = [
    {
      job_definition = "example-job-definition",
      job_name       = "example-job-name",
      array_size     = 5,
      job_attempts   = 3
    }
  ]

  # Kinesis Target
  kinesis_target = [
    {
      partition_key_path = "example-path"
    }
  ]

  # ECS Target with all its options including network_configuration
  ecs_target = [
    {
      capacity_provider_strategy = [
        {
          base              = 1,
          capacity_provider = "example-provider",
          weight            = 1
        }
      ],
      network_configuration = [
        {
          subnets          = ["subnet-0123456789abcdef0"],
          security_groups  = ["sg-0123456789abcdef0"],
          assign_public_ip = true
        }
      ],
      placement_constraint = [
        {
          type       = "distinctInstance",
          expression = "attribute:ecs.instance-type == t2.micro"
        }
      ],
      group               = "example-group",
      launch_type         = "EC2",
      platform_version    = "LATEST",
      task_count          = 1,
      task_definition_arn = "arn:aws:ecs:region:account-id:task-definition/task-name:task-version",
      tags = {
        "Name" = "example"
      },
      propagate_tags          = "TASK_DEFINITION",
      enable_execute_command  = true,
      enable_ecs_managed_tags = true
    }
  ]
}
