locals {
  account_id          = data.aws_caller_identity.current.account_id
  partition           = data.aws_partition.current.partition
  dns_suffix          = data.aws_partition.current.dns_suffix
  region              = data.aws_region.current.name
  task_definition_arn = data.aws_ecs_task_definition.main.arn
  private_subnets     = data.aws_subnets.private.ids
  cluster_arn         = data.aws_ecs_cluster.ecs.arn
  security_group      = data.aws_security_group.main.id
  organization_id     = data.aws_organizations_organization.currrent.id
  vpc_id              = data.aws_vpc.supporting.id

  name = "complete-event-bridge-example"
  tags = {
    Name               = local.name
    Environment        = "examples"
    "user::CostCenter" = "terraform"
    department         = "operations"
    instance-scheduler = false
    LayerName          = "c950-aws-event-bridge"
    LayerId            = "c950"
  }
  content = jsonencode({
    "schemaVersion" : "1.2",
    "description" : "Stop an instances at 1900Hrs in the evening everyday",
    "parameters" : {},
    "runtimeConfig" : {
      "aws:runShellScript" : {
        "properties" : [
          {
            "id" : "0.aws:runShellScript",
            "runCommand" : ["halt"]
          }
        ]
      }
    }
  })

  secrets_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid    = "EnablePermissions",
          Effect = "Allow",
          Principal = {
            AWS = "arn:${local.partition}:iam::${local.account_id}:root"
          },
          Action   = "secretsmanager:GetSecretValue",
          Resource = "*"
        }
      ]
  })

  api_assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })

  api_gw_cloudwatch_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        Resource = "*",
        Effect   = "Allow"
      }
    ]
  })
}
