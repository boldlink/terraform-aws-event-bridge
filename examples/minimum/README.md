[![License](https://img.shields.io/badge/License-Apache-blue.svg)](https://github.com/boldlink/terraform-aws-event-bridge/blob/main/LICENSE)
[![Latest Release](https://img.shields.io/github/release/boldlink/terraform-aws-event-bridge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/releases/latest)
[![Build Status](https://github.com/boldlink/terraform-aws-event-bridge/actions/workflows/update.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-event-bridge/actions/workflows/release.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-event-bridge/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-event-bridge/actions/workflows/pr-labeler.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-event-bridge/actions/workflows/module-examples-tests.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-event-bridge/actions/workflows/checkov.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-event-bridge/actions/workflows/auto-merge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/actions)
[![Build Status](https://github.com/boldlink/terraform-aws-event-bridge/actions/workflows/auto-badge.yaml/badge.svg)](https://github.com/boldlink/terraform-aws-event-bridge/actions)

[<img src="https://avatars.githubusercontent.com/u/25388280?s=200&v=4" width="96"/>](https://boldlink.io)

# Terraform module example with minimum configuration

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.24.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_minumum_example"></a> [minumum\_example](#module\_minumum\_example) | ../.. | n/a |
| <a name="module_sns"></a> [sns](#module\_sns) | boldlink/sns/aws | 1.1.1 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
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

#### BOLDLink-SIG 2023
