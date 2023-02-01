stack {
  name        = "terraform-google-cloud-run"
  description = "github.com/mineiros-io/terraform-google-cloud-run"
  tags        = ["module"]
}

terramate {
  required_version = "~> 0.2.9"
}

generate_hcl "versions.tf" {
  condition = tm_contains(terramate.stack.tags, "module")

  content {
    terraform {
      required_version = global.terraform_version_constraint

      tm_dynamic required_providers {
        attributes = {
          "${global.provider}" = {
            source  = "hashicorp/${global.provider}"
            version = global.provider_version_constraint
          }
        }
      }
    }
  }
}
