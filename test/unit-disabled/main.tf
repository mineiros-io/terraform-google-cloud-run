module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments

  name     = "test"
  location = "europe-west3"

  template = {
    spec = {
      containers = [
        {
          image = "gcr.io/cloudrun/hello:latest"
        }
      ]
    }
  }

  # add all optional arguments that create additional/extended resources

  iam = [
    {
      role    = "roles/run.invoker"
      members = ["domain:${local.org_domain}"]
    }
  ]
}
