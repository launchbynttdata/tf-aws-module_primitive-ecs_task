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

