# ============================================
# LOCAL VALUES AND COMPUTED EXPRESSIONS
# ============================================

locals {
  # Process secrets from Secrets Manager
  secrets_manager_secrets_list = [
    for env_name, secret_arn in var.secrets_manager_secrets : {
      name      = env_name
      valueFrom = secret_arn
    }
  ]

  # Combine all secrets (new format + legacy format)
  all_container_secrets = concat(
    local.secrets_manager_secrets_list,
    var.container_secrets
  )

  # Validation helpers
  has_secrets = length(local.all_container_secrets) > 0

  # Process container definitions - handle both JSON string and object formats
  # Merge secrets into container definitions
  container_definitions_with_secrets = [
    for container in var.container_definitions : merge(container, {
      secrets = length(local.all_container_secrets) > 0 ? local.all_container_secrets : (
        lookup(container, "secrets", null) != null ? container.secrets : []
      )
    })
  ]

  # Always convert container definitions to JSON string for consistency
  container_definitions_json = jsonencode(local.container_definitions_with_secrets)

  # Validate container definitions structure
  container_definitions_parsed = local.container_definitions_with_secrets

  # Extract container names for validation
  container_names = [for container in local.container_definitions_parsed : container.name]
}
