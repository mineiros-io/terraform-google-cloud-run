locals {
  iam_map = { for iam in var.iam : iam.role => iam }
}

module "iam" {
  source = "github.com/mineiros-io/terraform-google-cloud-run-iam?ref=v0.0.2"

  for_each = var.policy_bindings == null ? local.iam_map : {}

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  project = var.project

  service  = try(google_cloud_run_service.service[0].name, null)
  location = try(google_cloud_run_service.service[0].location, null)

  role            = try(each.value.role, null)
  members         = try(each.value.members, null)
  authoritative   = try(each.value.authoritative, true)
  policy_bindings = try(each.value.policy_bindings, null)
}

moved {
  from = module.iam["iam_policy"]
  to   = module.policy_bindings[0]
}

module "policy_bindings" {
  source = "github.com/mineiros-io/terraform-google-cloud-run-iam?ref=v0.0.2"

  count = var.policy_bindings != null ? 1 : 0

  module_enabled    = var.module_enabled
  module_depends_on = var.module_depends_on

  project = var.project

  service  = try(google_cloud_run_service.service[0].name, null)
  location = try(google_cloud_run_service.service[0].location, null)

  policy_bindings = try(each.value.policy_bindings, null)
}
