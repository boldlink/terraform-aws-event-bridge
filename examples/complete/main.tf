### Note: In order to use this example against an instance, the following must be in place. The instance must:
### Have the AWS Systems Manager Agent (SSM Agent) installed and running.
### Have connectivity with Systems Manager endpoints using the SSM Agent (hence should have internet connectivity or use vpc endpoint).
### Have the correct AWS Identity and Access Management (IAM) role attached. (ensure `AmazonSSMManagedInstanceCore` policy is attached)
### Have connectivity to the instance metadata service.
resource "random_string" "user" {
  length  = 5
  special = false
  upper   = false
  numeric = false
}

resource "random_password" "master_password" {
  length  = 16
  special = false
  upper   = true
}

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

  retry_policy = [
    {
      maximum_event_age_in_seconds = 3600
      maximum_retry_attempts       = 3
    }
  ]
}

resource "aws_iam_role" "ecs_events" {
  name               = "ecs_events"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  name   = "ecs_events_run_task_with_any_role"
  role   = aws_iam_role.ecs_events.id
  policy = data.aws_iam_policy_document.ecs_events_run_task_with_any_role.json
}

module "ecs_target" {
  source              = "../.."
  name                = "${local.name}-ecs"
  description         = "Extended Event bridge rule example"
  schedule_expression = "cron(0 19 * * ? *)"
  target_id           = "ECSTarget"
  arn                 = local.cluster_arn
  target_role_arn     = aws_iam_role.ecs_events.arn
  tags                = local.tags

  input = jsonencode({
    containerOverrides = [
      {
        name = var.supporting_resources_name,
        command = [
          "bin/console",
          "scheduled-task"
        ]
      }
    ]
  })

  # ECS Target with all its options including network_configuration
  ecs_target = [
    {
      capacity_provider_strategy = {
        base              = 1
        capacity_provider = "example-provider"
        weight            = 1
      }

      # Parameter AssignPublicIp for target ECSTarget is not supported when launch type is EC2
      network_configuration = {
        subnets         = flatten(local.private_subnets)
        security_groups = [local.security_group]
      }

      placement_constraint = {
        type       = "distinctInstance"
        expression = "attribute:ecs.instance-type == t2.micro"
      }

      # Parameter PlatformVersion for target ECSTarget is not supported when launch type is EC2
      group               = "example-group"
      launch_type         = "EC2"
      task_count          = 1
      task_definition_arn = local.task_definition_arn

      tags = {
        "Name" = "example"
      }

      propagate_tags          = "TASK_DEFINITION"
      enable_execute_command  = true
      enable_ecs_managed_tags = true
    }
  ]
}

###http target
resource "aws_iam_role" "api_gw_cloudwatch" {
  name               = "APIGatewayCloudWatchRole"
  assume_role_policy = local.api_assume_role_policy
}

resource "aws_iam_role_policy" "api_gw_cloudwatch" {
  #checkov:skip=CKV_AWS_290: "Ensure IAM policies does not allow write access without constraints"
  #checkov:skip=CKV_AWS_355
  name   = "APIGatewayCloudWatchPolicy"
  role   = aws_iam_role.api_gw_cloudwatch.id
  policy = local.api_gw_cloudwatch_policy

}

resource "aws_api_gateway_account" "main" {
  cloudwatch_role_arn = aws_iam_role.api_gw_cloudwatch.arn
  depends_on          = [aws_iam_role_policy.api_gw_cloudwatch]
}

resource "aws_api_gateway_rest_api" "main" {
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "example"
      version = "1.0"
    }
    paths = {
      "/path1" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
  })

  lifecycle {
    create_before_destroy = true
  }
  name = "example"
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.main.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "main" {
  #checkov:skip=CKV_AWS_120: "Ensure API Gateway caching is enabled"
  #checkov:skip=CKV_AWS_76: "Ensure API Gateway has Access Logging enabled"
  #checkov:skip=CKV_AWS_73: "Ensure API Gateway has X-Ray Tracing enabled"
  #checkov:skip=CKV2_AWS_51: "Ensure AWS API Gateway endpoints uses client certificate authentication"
  #checkov:skip=CKV2_AWS_29: "Ensure public API gateway are protected by WAF"
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = "example"
}

resource "aws_api_gateway_method_settings" "main" {
  #checkov:skip=CKV_AWS_225: "Ensure API Gateway method setting caching is enabled"
  #checkov:skip=CKV_AWS_308: "Ensure API Gateway method setting caching is set to encrypted"
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  method_path = "*/*"
  depends_on  = [aws_api_gateway_account.main]

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

module "http_target" {
  source      = "../.."
  name        = "capture-ec2-scaling-events"
  description = "Capture all EC2 scaling events"
  target_id   = "CaptureInstancesEvents"
  arn         = "${aws_api_gateway_stage.main.execution_arn}/GET"
  tags        = local.tags

  event_pattern = jsonencode({
    source = [
      "aws.autoscaling"
    ]

    detail-type = [
      "EC2 Instance Launch Successful",
      "EC2 Instance Terminate Successful",
      "EC2 Instance Launch Unsuccessful",
      "EC2 Instance Terminate Unsuccessful"
    ]
  })

  http_target = [
    {
      query_string_parameters = {
        "param1" = "value1"
        "param2" = "value2"
      }
      header_parameters = {
        "header1" = "value1"
        "header2" = "value2"
      }
    }
  ]

  input_transformer = [
    {
      input_paths = {
        instance = "$.detail.instance",
        status   = "$.detail.status",
      }
      input_template = <<EOF
{
  "instance_id": <instance>,
  "instance_status": <status>
}
EOF
    }
  ]

  event_permissions = [
    {
      principal    = "*"
      statement_id = "OrganizationAccess"
      action       = "events:PutEvents"
      condition = {
        key   = "aws:PrincipalOrgID"
        type  = "StringEquals"
        value = local.organization_id
      }
    }
  ]
}

## Other targets
resource "aws_redshift_cluster" "example" {
  #checkov:skip=CKV_AWS_64: "Ensure all data stored in the Redshift cluster is securely encrypted at rest"
  #checkov:skip=CKV_AWS_142: "Ensure that Redshift cluster is encrypted by KMS"
  #checkov:skip=CKV_AWS_321: "Ensure Redshift clusters use enhanced VPC routing"
  #checkov:skip=CKV_AWS_188: "Ensure RedShift Cluster is encrypted by KMS using a customer managed Key (CMK)"
  #checkov:skip=CKV_AWS_71: "Ensure Redshift Cluster logging is enabled"
  #checkov:skip=CKV_AWS_87: "Redshift cluster should not be publicly accessible"
  #checkov:skip=CKV_SECRET_6: "Base64 High Entropy String"
  cluster_identifier        = "${var.name}-redshift-cluster"
  database_name             = "example_database"
  master_username           = "exampleuser"
  master_password           = random_password.master_password.result
  node_type                 = "dc2.large"
  cluster_type              = "single-node"
  skip_final_snapshot       = true
  vpc_security_group_ids    = [aws_security_group.rs.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.example.name
  port                      = 5439

  depends_on = [
    aws_redshift_subnet_group.example,
    aws_security_group.rs
  ]
}

resource "aws_redshift_subnet_group" "example" {
  name       = var.name
  subnet_ids = flatten(local.private_subnets)
  tags       = var.tags
}

resource "aws_security_group" "rs" {
  name        = "${var.name}-rs-sg"
  description = "Example rs Security Group"
  vpc_id      = local.vpc_id
}

module "secrets" {
  source        = "boldlink/secretsmanager/aws"
  version       = "1.0.8"
  name          = var.name
  description   = "RS secrets"
  secret_policy = local.secrets_policy
  tags          = var.tags

  secrets = {
    creds = {
      secret_string = jsonencode(
        {
          username = random_string.user.result
          password = random_password.master_password.result
        }
      )
    }
  }
}

resource "aws_iam_role" "others" {
  name               = "${var.name}-others"
  assume_role_policy = data.aws_iam_policy_document.assume_others.json
}

resource "aws_iam_role_policy_attachment" "redshift_s3_read_write" {
  role       = aws_iam_role.others.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "batch_service" {
  role       = aws_iam_role.others.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_iam_role_policy_attachment" "sqs_full_access" {
  role       = aws_iam_role.others.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

module "redshift_target" {
  source              = "../../"
  name                = "${var.name}-rs-target"
  description         = "RS bridge rule example"
  schedule_expression = "cron(0 19 * * ? *)"
  target_id           = "RSTarget"
  arn                 = aws_redshift_cluster.example.arn
  target_role_arn     = aws_iam_role.others.arn
  tags                = var.tags

  redshift_target = [
    {
      database = "example_database"
      #db_user             = "exampleuser" #either use db_user or secrets_manager_arn but not both
      secrets_manager_arn = module.secrets.arn
      sql                 = "SELECT * FROM example_table"
      statement_name      = "example_statement"
      with_event          = true
    }
  ]
}
