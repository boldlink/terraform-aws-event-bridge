locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
  dns_suffix = data.aws_partition.current.dns_suffix
  region     = data.aws_region.current.name

  name       = "minimum-event-bridge-example"
  topic_name = "aws-console-logins"
  tags = {
    Name               = local.name
    Environment        = "examples"
    "user::CostCenter" = "terraform"
    department         = "operations"
    instance-scheduler = false
    LayerName          = "c950-aws-event-bridge"
    LayerId            = "c950"
  }
  event_pattern = jsonencode({
    "detail-type" : [
      "AWS Console Sign In via CloudTrail"
    ]
  })

}
