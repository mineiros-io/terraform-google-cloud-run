# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------

# remap iam to reduce one level of access (iam[]. instead of iam[].iam.)
output "iam" {
  description = "The iam resource objects that define the access to the secret"
  value       = { for key, iam in module.iam : key => iam.iam }
}

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

output "service" {
  description = "All `google_cloud_run_service` resource attributes."
  value       = try(google_cloud_run_service.service[0], null)
}

output "domain_mapping" {
  description = "All `google_cloud_run_domain_mapping` resource attributes."
  value       = try(google_cloud_run_domain_mapping.domain_mapping[0], null)
}

# ------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled."
  value       = var.module_enabled
}
