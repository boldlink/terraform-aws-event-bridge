variable "name" {
  type        = string
  description = "Name of the stack"
  default     = "complete-event-bridge-example"
}

variable "supporting_resources_name" {
  type        = string
  description = "Name of the supporting resources stack"
  default     = "complete-event-bridge-example"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resources"
  default = {
    Environment        = "example"
    "user::CostCenter" = "terraform"
    Department         = "DevOps"
    Project            = "Examples"
    InstanceScheduler  = true
    Owner              = "Boldlink"
    LayerName          = "cExample"
    LayerId            = "cExample"
  }
}
