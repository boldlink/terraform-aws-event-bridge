[![Build Status](https://github.com/boldlink/terraform-aws-event-bridge/actions/workflows/release.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-event-bridge/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-event-bridge/actions/workflows/pr-labeler.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-event-bridge/actions/workflows/checkov.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-event-bridge/actions/workflows/auto-badge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/actions)

[<img src="https://avatars.githubusercontent.com/u/25388280?s=200&v=4" width="96"/>](https://boldlink.io)

# Aws Event Bridge Terraform Module

## Description

This module creates aws cloudwatch event bridge, event target, event permissions and resources necessary to create and use the aforementioned resources

Examples available [`here`](./examples)

## Usage
*NOTE*: These examples use the latest version of this module

```console
module "miniumum" {
  source  = "boldlink/<module_name>/<provider>"
  version = "x.x.x"
  <insert the minimum required variables here if any are required>
  ...
}
```
## Documentation

[AWS Event Bridge Documentation](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html)

[Terraform module documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.37.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_permission.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_permission) | resource |
| [aws_cloudwatch_event_rule.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arn"></a> [arn](#input\_arn) | (Required) The Amazon Resource Name (ARN) of the target. | `string` | n/a | yes |
| <a name="input_batch_target"></a> [batch\_target](#input\_batch\_target) | (Optional) Parameters used when you are using the rule to invoke an Amazon Batch Job. | `map(string)` | `{}` | no |
| <a name="input_dead_letter_config"></a> [dead\_letter\_config](#input\_dead\_letter\_config) | (Optional) Parameters used when you are providing a dead letter config. | `map(string)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the rule. | `string` | `null` | no |
| <a name="input_ecs_target"></a> [ecs\_target](#input\_ecs\_target) | (Optional) Parameters used when you are using the rule to invoke Amazon ECS Task. | `map(string)` | `{}` | no |
| <a name="input_event_bus_name"></a> [event\_bus\_name](#input\_event\_bus\_name) | (Optional) The event bus to associate with this rule. If you omit this, the `default` event bus is used. | `string` | `"default"` | no |
| <a name="input_event_pattern"></a> [event\_pattern](#input\_event\_pattern) | (Optional) The event pattern described a JSON object. At least one of `schedule_expression` or `event_pattern` is required. | `string` | `null` | no |
| <a name="input_event_permissions"></a> [event\_permissions](#input\_event\_permissions) | EventBridge permissions to support cross-account events in the current account default event bus. | `any` | `[]` | no |
| <a name="input_http_target"></a> [http\_target](#input\_http\_target) | (Optional) Parameters used when you are using the rule to invoke an API Gateway REST endpoint. | `map(string)` | `{}` | no |
| <a name="input_input"></a> [input](#input\_input) | (Optional) Valid JSON text passed to the target. Conflicts with `input_path` and `input_transformer`. | `string` | `null` | no |
| <a name="input_input_path"></a> [input\_path](#input\_input\_path) | (Optional) The value of the JSONPath that is used for extracting part of the matched event when passing it to the target. Conflicts with `input` and `input_transformer`. | `string` | `null` | no |
| <a name="input_input_transformer"></a> [input\_transformer](#input\_input\_transformer) | (Optional) Parameters used when you are providing a custom input to a target based on certain event data. Conflicts with `input` and `input_path`. | `map(string)` | `{}` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | (Optional) Whether the rule should be enabled (defaults to `true`). | `bool` | `true` | no |
| <a name="input_kinesis_target"></a> [kinesis\_target](#input\_kinesis\_target) | (Optional) Parameters used when you are using the rule to invoke an Amazon Kinesis Stream. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) The name of the rule. If omitted, Terraform will assign a random, unique name. Conflicts with `name_prefix`. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | (Optional) Creates a unique name beginning with the specified prefix. Conflicts with `name`. | `string` | `null` | no |
| <a name="input_redshift_target"></a> [redshift\_target](#input\_redshift\_target) | (Optional) Parameters used when you are using the rule to invoke an Amazon Redshift Statement. | `map(string)` | `{}` | no |
| <a name="input_retry_policy"></a> [retry\_policy](#input\_retry\_policy) | (Optional) Parameters used when you are providing retry policies. | `map(string)` | `{}` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | (Optional) The Amazon Resource Name (ARN) associated with the role that is used for target invocation. | `string` | `null` | no |
| <a name="input_run_command_targets"></a> [run\_command\_targets](#input\_run\_command\_targets) | (Optional) List of Parameters used when you are using the rule to invoke Amazon EC2 Run Command. | `list(any)` | `[]` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | (Optional) The scheduling expression. For example, `cron(0 20 * * ? *)` or `rate(5 minutes)`. At least one of `schedule_expression` or `event_pattern` is required. Can only be used on the default event bus. | `string` | `null` | no |
| <a name="input_sqs_target"></a> [sqs\_target](#input\_sqs\_target) | (Optional) Parameters used when you are using the rule to invoke an Amazon SQS Queue. | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_target_id"></a> [target\_id](#input\_target\_id) | (Optional) The unique target assignment ID. If missing, will generate a random, unique id. | `string` | `null` | no |
| <a name="input_target_role_arn"></a> [target\_role\_arn](#input\_target\_role\_arn) | (Optional) The Amazon Resource Name (ARN) of the IAM role to be used for this target when the rule is triggered. Required if `ecs_target` is used or target in arn is EC2 instance, Kinesis data stream, Step Functions state machine, or Event Bus in different account or region. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rule_arn"></a> [rule\_arn](#output\_rule\_arn) | The Amazon Resource Name (ARN) of the rule. |
| <a name="output_rule_id"></a> [rule\_id](#output\_rule\_id) | The name of the rule. |
| <a name="output_rule_tags_all"></a> [rule\_tags\_all](#output\_rule\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Third party software
This repository uses third party software:
* [pre-commit](https://pre-commit.com/) - Used to help ensure code and documentation consistency
  * Install with `brew install pre-commit`
  * Manually use with `pre-commit run`
* [terraform 0.14.11](https://releases.hashicorp.com/terraform/0.14.11/) For backwards compatibility we are using version 0.14.11 for testing making this the min version tested and without issues with terraform-docs.
* [terraform-docs](https://github.com/segmentio/terraform-docs) - Used to generate the [Inputs](#Inputs) and [Outputs](#Outputs) sections
  * Install with `brew install terraform-docs`
  * Manually use via pre-commit
* [tflint](https://github.com/terraform-linters/tflint) - Used to lint the Terraform code
  * Install with `brew install tflint`
  * Manually use via pre-commit

### Supporting resources:

The example stacks are used by BOLDLink developers to validate the modules by building an actual stack on AWS.

Some of the modules have dependencies on other modules (ex. Ec2 instance depends on the VPC module) so we create them
first and use data sources on the examples to use the stacks.

Any supporting resources will be available on the `tests/supportingResources` and the lifecycle is managed by the `Makefile` targets.

Resources on the `tests/supportingResources` folder are not intended for demo or actual implementation purposes, and can be used for reference.

### Makefile
The makefile contained in this repo is optimized for linux paths and the main purpose is to execute testing for now.
* Create all tests stacks including any supporting resources:
```console
make tests
```
* Clean all tests *except* existing supporting resources:
```console
make clean
```
* Clean supporting resources - this is done separately so you can test your module build/modify/destroy independently.
```console
make cleansupporting
```
* !!!DANGER!!! Clean the state files from examples and test/supportingResources - use with CAUTION!!!
```console
make cleanstatefiles
```


#### BOLDLink-SIG 2022
