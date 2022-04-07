# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# EXAMPLE FULL USAGE OF THE TERRAFORM-GOOGLE-CLOUD-RUN MODULE
#
# And some more meaningful information.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "terraform-google-cloud-run" {
  source = "git@github.com:mineiros-io/terraform-google-cloud-run.git?ref=v0.0.2"

  # All required module arguments
  name     = "mineiros-cloud-run-example"
  location = "europe-north1"

  # All optional module arguments set to the default values

  # none

  # All optional module configuration arguments set to the default values.
  # Those are maintained for terraform 0.12 but can still be used in terraform 0.13
  # Starting with terraform 0.13 you can additionally make use of module level
  # count, for_each and depends_on features.
  module_enabled    = true
  module_depends_on = []
}

# ----------------------------------------------------------------------------------------------------------------------
# EXAMPLE PROVIDER CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

provider "google" {
  version = "~> 4.0"
}
