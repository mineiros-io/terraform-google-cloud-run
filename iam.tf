locals {
  # filter all objects that define a single role
  iam_role = [for iam in var.iam : iam if can(iam.role)]

  # filter all objects that define multiple roles and expand them to single roles
  iam_roles = flatten([for iam in var.iam :
    [for role in iam.roles : merge(iam, { role = role })] if can(iam.roles)
  ])

  iam = concat(local.iam_role, local.iam_roles)

  iam_map = { for idx, iam in local.iam :
    try(iam._key, iam.role) => iam
  }
}

module "iam" {
  source = "github.com/mineiros-io/terraform-google-cloud-run-iam?ref=v0.1.0"

  # Hack ternary in Terraform to prevent
  #   "Error: Inconsistent conditional result types"
  #   "The true and false result expressions must have consistent types."
  for_each = [local.iam_map, {}][var.policy_bindings == null ? 0 : 1]

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  project = var.project

  service  = try(google_cloud_run_service.service[0].name, null)
  location = try(google_cloud_run_service.service[0].location, null)

  role                 = try(each.value.role, null)
  members              = try(each.value.members, null)
  authoritative        = try(each.value.authoritative, true)
  policy_bindings      = try(each.value.policy_bindings, null)
  computed_members_map = var.computed_members_map
}

moved {
  from = module.iam["iam_policy"]
  to   = module.policy_bindings[0]
}

module "policy_bindings" {
  source = "github.com/mineiros-io/terraform-google-cloud-run-iam?ref=v0.1.0"

  count = var.policy_bindings != null ? 1 : 0

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  project = var.project

  service  = try(google_cloud_run_service.service[0].name, null)
  location = try(google_cloud_run_service.service[0].location, null)

  policy_bindings      = var.policy_bindings
  computed_members_map = var.computed_members_map
}
