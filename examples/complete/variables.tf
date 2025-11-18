
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

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "task_family_prefix" {
  description = "Prefix for task family name"
  type        = string
}

variable "requires_compatibilities" {
  description = "Compatibility requirements for the task definition"
  type        = list(string)
}

variable "network_mode" {
  description = "Network mode for the task"
  type        = string
}

variable "cpu" {
  description = "CPU units for the task"
  type        = string
}

variable "memory" {
  description = "Memory for the task"
  type        = string
}

variable "ephemeral_storage_size" {
  description = "Ephemeral storage size in GiB"
  type        = number
}

variable "operating_system_family" {
  description = "Operating system family"
  type        = string
}

variable "cpu_architecture" {
  description = "CPU architecture"
  type        = string
}

variable "container_definitions" {
  description = "Container definitions for the task"
  type = list(object({
    name      = string
    image     = string
    cpu       = number
    memory    = number
    essential = bool
    environment = optional(list(object({
      name  = string
      value = string
    })), [])
    portMappings = optional(list(object({
      containerPort = number
      protocol      = string
      name          = optional(string)
    })), [])
    logConfiguration = optional(object({
      logDriver = string
      options   = map(string)
    }))
    healthCheck = optional(object({
      command     = list(string)
      interval    = number
      timeout     = number
      retries     = number
      startPeriod = number
    }))
    command = optional(list(string), [])
    dependsOn = optional(list(object({
      containerName = string
      condition     = string
    })), [])
  }))
}

variable "task_tags" {
  description = "Tags for the task definition"
  type        = map(string)
}

variable "execution_role_name_prefix" {
  description = "Prefix for ECS execution role name"
  type        = string
}

variable "task_role_name_prefix" {
  description = "Prefix for ECS task role name"
  type        = string
}

variable "task_policy_name_prefix" {
  description = "Prefix for task role policy name"
  type        = string
}

variable "example_name" {
  description = "Example name for tagging"
  type        = string
}
