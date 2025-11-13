# ============================================
# ECS TASK DEFINITION PRIMITIVE VARIABLES
# ============================================

# Core ECS Task Definition Variables
variable "family" {
  description = "The family name of the ECS task definition"
  type        = string

  validation {
    condition     = length(var.family) > 0 && length(var.family) <= 255
    error_message = "Task definition family must be between 1 and 255 characters."
  }
}

variable "requires_compatibilities" {
  description = "The launch types required by the task (e.g., FARGATE, EC2)"
  type        = list(string)
  default     = ["FARGATE"]

  validation {
    condition = alltrue([
      for compat in var.requires_compatibilities : contains(["EC2", "FARGATE", "EXTERNAL"], compat)
    ])
    error_message = "Requires compatibilities must be one of: EC2, FARGATE, EXTERNAL."
  }
}

variable "network_mode" {
  description = "The Docker networking mode to use for the containers in the task"
  type        = string
  default     = "awsvpc"

  validation {
    condition     = contains(["none", "bridge", "awsvpc", "host"], var.network_mode)
    error_message = "Network mode must be one of: none, bridge, awsvpc, host."
  }
}

variable "cpu" {
  description = "The number of CPU units used by the task"
  type        = string
  default     = "256"

  validation {
    condition = contains([
      "256", "512", "1024", "2048", "4096", "8192", "16384"
    ], var.cpu)
    error_message = "CPU must be one of the valid values: 256, 512, 1024, 2048, 4096, 8192, 16384."
  }
}

variable "memory" {
  description = "The amount (in MiB) of memory used by the task"
  type        = string
  default     = "512"

  validation {
    condition     = can(tonumber(var.memory)) && tonumber(var.memory) >= 512
    error_message = "Memory must be a valid number and at least 512 MiB."
  }
}

variable "execution_role_arn" {
  description = "The ARN of the task execution role that containers can assume"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_-]+$", var.execution_role_arn))
    error_message = "Execution role ARN must be a valid IAM role ARN."
  }
}

variable "task_role_arn" {
  description = "The ARN of the IAM role that containers in this task can assume"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_-]+$", var.task_role_arn))
    error_message = "Task role ARN must be a valid IAM role ARN."
  }
}

# Container Definition Variables
variable "container_definitions" {
  description = "Container definitions as a list of objects or JSON string. Will be automatically converted to JSON format."
  type        = any

  validation {
    condition     = length(var.container_definitions) > 0
    error_message = "At least one container definition must be provided."
  }
}

# Secrets Manager Configuration
variable "secrets_manager_secrets" {
  description = "Map of environment variable names to Secrets Manager secret ARNs or names"
  type        = map(string)
  default     = {}
}

# Legacy container secrets (for backward compatibility)
variable "container_secrets" {
  description = "List of secrets to pass to container (legacy format)"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

# Optional Task Definition Attributes
variable "ephemeral_storage" {
  description = "The amount of ephemeral storage to allocate for the task"
  type = object({
    size_in_gib = number
  })
  default = null
}

variable "ipc_mode" {
  description = "The IPC resource namespace to be used for the containers in the task"
  type        = string
  default     = null
}

variable "pid_mode" {
  description = "The process namespace to use for the containers in the task"
  type        = string
  default     = null
}

variable "skip_destroy" {
  description = "Whether to skip destroying the task definition"
  type        = bool
  default     = false
}

variable "track_latest" {
  description = "Whether the ECS service should track the latest ACTIVE revision"
  type        = bool
  default     = false
}

# Placement Constraints
variable "placement_constraints" {
  description = "Configuration block for placement constraints"
  type = list(object({
    type       = string
    expression = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for pc in var.placement_constraints : contains(["memberOf", "distinctInstance"], pc.type)
    ])
    error_message = "Placement constraint type must be 'memberOf' or 'distinctInstance'."
  }
}

# Proxy Configuration
variable "proxy_configuration" {
  description = "Configuration block for the proxy configuration"
  type = object({
    type           = string
    container_name = string
    properties     = optional(map(string), {})
  })
  default = null
}

# Runtime Platform
variable "runtime_platform" {
  description = "Configuration block for runtime platform"
  type = object({
    operating_system_family = optional(string)
    cpu_architecture        = optional(string)
  })
  default = null
}

# Volumes
variable "volumes" {
  description = "Configuration block for volumes"
  type = list(object({
    name      = string
    host_path = optional(string)
    docker_volume_configuration = optional(object({
      scope         = optional(string)
      autoprovision = optional(bool)
      driver        = optional(string)
      driver_opts   = optional(map(string))
      labels        = optional(map(string))
    }))
    efs_volume_configuration = optional(object({
      file_system_id          = string
      root_directory          = optional(string)
      transit_encryption      = optional(string)
      transit_encryption_port = optional(number)
      authorization_config = optional(object({
        access_point_id = optional(string)
        iam             = optional(string)
      }))
    }))
    fsx_windows_file_server_volume_configuration = optional(object({
      file_system_id = string
      root_directory = string
      authorization_config = object({
        credentials_parameter = string
        domain                = string
      })
    }))
  }))
  default = []
}

# Tags
variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

# Fault Injection
variable "enable_fault_injection" {
  description = "Enables fault injection and allows for fault injection requests to be accepted from the task's containers"
  type        = bool
  default     = false
}
