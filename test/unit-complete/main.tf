module "test" {
  source = "../.."

  # add all required arguments

  name     = "test-${local.random_suffix}"
  location = "europe-west3"

  project = local.project_id

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

  # add most/all other optional arguments
}
