// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = module.ecs_task_definition.arn
}

output "task_definition_family" {
  description = "Family of the task definition"
  value       = module.ecs_task_definition.family
}

output "task_definition_revision" {
  description = "Revision of the task definition"
  value       = module.ecs_task_definition.revision
}

output "execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "execution_role_name" {
  description = "Name of the ECS task execution role"
  value       = aws_iam_role.ecs_execution_role.name
}

output "task_role_name" {
  description = "Name of the ECS task role"
  value       = aws_iam_role.ecs_task_role.name
}

output "tags" {
  description = "Tags assigned to the task definition"
  value       = module.ecs_task_definition.tags_all
}

output "tags_all" {
  description = "All tags assigned to the task definition"
  value       = module.ecs_task_definition.tags_all
}

