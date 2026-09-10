# complete

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_task_definition"></a> [ecs\_task\_definition](#module\_ecs\_task\_definition) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.ecs_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecs_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | Container definitions for the task | <pre>list(object({<br/>    name      = string<br/>    image     = string<br/>    cpu       = number<br/>    memory    = number<br/>    essential = bool<br/>    environment = optional(list(object({<br/>      name  = string<br/>      value = string<br/>    })), [])<br/>    portMappings = optional(list(object({<br/>      containerPort = number<br/>      protocol      = string<br/>      name          = optional(string)<br/>    })), [])<br/>    logConfiguration = optional(object({<br/>      logDriver = string<br/>      options   = map(string)<br/>    }))<br/>    healthCheck = optional(object({<br/>      command     = list(string)<br/>      interval    = number<br/>      timeout     = number<br/>      retries     = number<br/>      startPeriod = number<br/>    }))<br/>    command = optional(list(string), [])<br/>    dependsOn = optional(list(object({<br/>      containerName = string<br/>      condition     = string<br/>    })), [])<br/>  }))</pre> | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU units for the task | `string` | n/a | yes |
| <a name="input_cpu_architecture"></a> [cpu\_architecture](#input\_cpu\_architecture) | CPU architecture | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"dev"` | no |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | Ephemeral storage size in GiB | `number` | n/a | yes |
| <a name="input_example_name"></a> [example\_name](#input\_example\_name) | Example name for tagging | `string` | n/a | yes |
| <a name="input_execution_role_name_prefix"></a> [execution\_role\_name\_prefix](#input\_execution\_role\_name\_prefix) | Prefix for ECS execution role name | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Memory for the task | `string` | n/a | yes |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | Network mode for the task | `string` | n/a | yes |
| <a name="input_operating_system_family"></a> [operating\_system\_family](#input\_operating\_system\_family) | Operating system family | `string` | n/a | yes |
| <a name="input_requires_compatibilities"></a> [requires\_compatibilities](#input\_requires\_compatibilities) | Compatibility requirements for the task definition | `list(string)` | n/a | yes |
| <a name="input_task_family_prefix"></a> [task\_family\_prefix](#input\_task\_family\_prefix) | Prefix for task family name | `string` | n/a | yes |
| <a name="input_task_policy_name_prefix"></a> [task\_policy\_name\_prefix](#input\_task\_policy\_name\_prefix) | Prefix for task role policy name | `string` | n/a | yes |
| <a name="input_task_role_name_prefix"></a> [task\_role\_name\_prefix](#input\_task\_role\_name\_prefix) | Prefix for ECS task role name | `string` | n/a | yes |
| <a name="input_task_tags"></a> [task\_tags](#input\_task\_tags) | Tags for the task definition | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | ARN of the ECS task execution role |
| <a name="output_execution_role_name"></a> [execution\_role\_name](#output\_execution\_role\_name) | Name of the ECS task execution role |
| <a name="output_tags"></a> [tags](#output\_tags) | Tags assigned to the task definition |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | All tags assigned to the task definition |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | ARN of the task definition |
| <a name="output_task_definition_family"></a> [task\_definition\_family](#output\_task\_definition\_family) | Family of the task definition |
| <a name="output_task_definition_revision"></a> [task\_definition\_revision](#output\_task\_definition\_revision) | Revision of the task definition |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | ARN of the ECS task role |
| <a name="output_task_role_name"></a> [task\_role\_name](#output\_task\_role\_name) | Name of the ECS task role |
<!-- END_TF_DOCS -->
