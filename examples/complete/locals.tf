locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
  dns_suffix = data.aws_partition.current.dns_suffix
  region     = data.aws_region.current.name

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
}
