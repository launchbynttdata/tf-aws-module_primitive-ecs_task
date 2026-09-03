# tf-aws-module_primitive-ecs_task

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | Container definitions as a list of objects or JSON string. Will be automatically converted to JSON format. | `any` | n/a | yes |
| <a name="input_container_secrets"></a> [container\_secrets](#input\_container\_secrets) | List of secrets to pass to container (legacy format) | <pre>list(object({<br/>    name      = string<br/>    valueFrom = string<br/>  }))</pre> | `[]` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The number of CPU units used by the task | `string` | `"256"` | no |
| <a name="input_enable_fault_injection"></a> [enable\_fault\_injection](#input\_enable\_fault\_injection) | Enables fault injection and allows for fault injection requests to be accepted from the task's containers | `bool` | `false` | no |
| <a name="input_ephemeral_storage"></a> [ephemeral\_storage](#input\_ephemeral\_storage) | The amount of ephemeral storage to allocate for the task | <pre>object({<br/>    size_in_gib = number<br/>  })</pre> | `null` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | The ARN of the task execution role that containers can assume | `string` | n/a | yes |
| <a name="input_family"></a> [family](#input\_family) | The family name of the ECS task definition | `string` | n/a | yes |
| <a name="input_ipc_mode"></a> [ipc\_mode](#input\_ipc\_mode) | The IPC resource namespace to be used for the containers in the task | `string` | `null` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The amount (in MiB) of memory used by the task | `string` | `"512"` | no |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | The Docker networking mode to use for the containers in the task | `string` | `"awsvpc"` | no |
| <a name="input_pid_mode"></a> [pid\_mode](#input\_pid\_mode) | The process namespace to use for the containers in the task | `string` | `null` | no |
| <a name="input_placement_constraints"></a> [placement\_constraints](#input\_placement\_constraints) | Configuration block for placement constraints | <pre>list(object({<br/>    type       = string<br/>    expression = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_proxy_configuration"></a> [proxy\_configuration](#input\_proxy\_configuration) | Configuration block for the proxy configuration | <pre>object({<br/>    type           = string<br/>    container_name = string<br/>    properties     = optional(map(string), {})<br/>  })</pre> | `null` | no |
| <a name="input_requires_compatibilities"></a> [requires\_compatibilities](#input\_requires\_compatibilities) | The launch types required by the task (e.g., FARGATE, EC2) | `list(string)` | <pre>[<br/>  "FARGATE"<br/>]</pre> | no |
| <a name="input_runtime_platform"></a> [runtime\_platform](#input\_runtime\_platform) | Configuration block for runtime platform | <pre>object({<br/>    operating_system_family = optional(string)<br/>    cpu_architecture        = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_secrets_manager_secrets"></a> [secrets\_manager\_secrets](#input\_secrets\_manager\_secrets) | Map of environment variable names to Secrets Manager secret ARNs or names | `map(string)` | `{}` | no |
| <a name="input_skip_destroy"></a> [skip\_destroy](#input\_skip\_destroy) | Whether to skip destroying the task definition | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | The ARN of the IAM role that containers in this task can assume | `string` | n/a | yes |
| <a name="input_track_latest"></a> [track\_latest](#input\_track\_latest) | Whether the ECS service should track the latest ACTIVE revision | `bool` | `false` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | Configuration block for volumes | <pre>list(object({<br/>    name      = string<br/>    host_path = optional(string)<br/>    docker_volume_configuration = optional(object({<br/>      scope         = optional(string)<br/>      autoprovision = optional(bool)<br/>      driver        = optional(string)<br/>      driver_opts   = optional(map(string))<br/>      labels        = optional(map(string))<br/>    }))<br/>    efs_volume_configuration = optional(object({<br/>      file_system_id          = string<br/>      root_directory          = optional(string)<br/>      transit_encryption      = optional(string)<br/>      transit_encryption_port = optional(number)<br/>      authorization_config = optional(object({<br/>        access_point_id = optional(string)<br/>        iam             = optional(string)<br/>      }))<br/>    }))<br/>    fsx_windows_file_server_volume_configuration = optional(object({<br/>      file_system_id = string<br/>      root_directory = string<br/>      authorization_config = object({<br/>        credentials_parameter = string<br/>        domain                = string<br/>      })<br/>    }))<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the ECS task definition |
| <a name="output_arn_without_revision"></a> [arn\_without\_revision](#output\_arn\_without\_revision) | The ARN of the ECS task definition without revision |
| <a name="output_container_definitions"></a> [container\_definitions](#output\_container\_definitions) | The container definitions in JSON format |
| <a name="output_container_names"></a> [container\_names](#output\_container\_names) | List of container names in the task definition |
| <a name="output_cpu"></a> [cpu](#output\_cpu) | The number of CPU units used by the task |
| <a name="output_enable_fault_injection"></a> [enable\_fault\_injection](#output\_enable\_fault\_injection) | Whether fault injection is enabled for the task definition |
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | The ARN of the task execution role |
| <a name="output_family"></a> [family](#output\_family) | The family of the ECS task definition |
| <a name="output_memory"></a> [memory](#output\_memory) | The amount of memory (in MiB) used by the task |
| <a name="output_network_mode"></a> [network\_mode](#output\_network\_mode) | The Docker networking mode used by the task |
| <a name="output_placement_constraints"></a> [placement\_constraints](#output\_placement\_constraints) | The placement constraints for the task |
| <a name="output_requires_compatibilities"></a> [requires\_compatibilities](#output\_requires\_compatibilities) | The launch types required by the task |
| <a name="output_revision"></a> [revision](#output\_revision) | The revision of the ECS task definition |
| <a name="output_tags_all"></a> [tags\_all](#output\_tags\_all) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | The ARN of the task role |
| <a name="output_track_latest"></a> [track\_latest](#output\_track\_latest) | Whether the ECS service tracks the latest ACTIVE revision |
| <a name="output_volumes"></a> [volumes](#output\_volumes) | The volume configuration for the task |
<!-- END_TF_DOCS -->

## Module Development

### Pre-Requisites

The following commands should be available on your system:

- `asdf` or `mise`
- `make`
- `python3` (for pre-commit)

Additionally, your `git` user and email must be configured. Run the `make configure` command from the root of the repository to ensure that you meet these requirements.

### Pre-Commit hooks

The [.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to Terraform and Golang, as well as some common linting tasks. These will be configured for you when you run `make configure`.

### Local Validation

You should validate the changes you make to any module locally, prior to pushing your changes in a branch to GitHub.

1. Ensure that you have run `make configure` successfully.

2. Ensure you are signed into the appropriate cloud provider (e.g. AWS or Azure) for the module under test in your current console session.

3. Run the Terraform and Golang linters with the following command:

```
make lint
```

4. Once you have satisfied the linters, the following command will build example infrastructure in your configured cloud, run the tests, and then tear down the infrastructure it created:

```
make test
```

The pre-commit validations, as well as the `make lint` and `make test` targets, will all be performed in CI. Running these validations locally prior to opening a PR helps ensure a smooth review and merge process.

### Review & Merge Process

Once your change has been tested locally and your branch pushed up, open a new Pull Request for your branch to the default (main) branch of this repository.

The title of your Pull Request will determine the version bump for this change, and the title must be in [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#specification) format in order to merge. A breaking change will trigger a major version bump, a feature will trigger a minor version bump, and all other types will trigger a patch version bump.

Ensure your CI workflows are passing; seek approval from teammates and address any feedback; seek any explicit approvals required by the CODEOWNERS file. You may merge the PR as soon as all requirements are met, and a new release and tag will be automatically created for you.

### Automatic Updates

The shared configuration and workflow files in this repository are largely managed through the [launch-terraform-skeleton](https://github.com/launchbynttdata/launch-terraform-skeleton) repository. Outside of perhaps the `.gitignore` to account for specific files being generated by certain Terraform modules (e.g. Lambda functions), there should not be much cause to update these files on a per-repo basis, and making changes to them individually is discouraged.

If desired, you can check for and run these updates locally in a branch if you have the `copier` tool installed. Some example commands are included below:

```
# Check for updates, optionally checking prerelease versions
copier check-update [--prereleases]

# Run an update, using default answers if there are any. We use tasks, which requires --trust to be set.
copier update --defaults --trust [--prereleases]

# Recopy from the source, and --overwrite all templated files in the process
copier recopy --defaults --trust --overwrite [--prereleases]
```

Automatic updates will run through a scheduled workflow, and if the post-update tests are successful, the Pull Request created will automatically merge. Conflicts in the update or failures to test may leave a Pull Request outstanding, which needs to be addressed by a Launch Engineer.
