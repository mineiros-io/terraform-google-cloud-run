module "test" {
  source = "../.."

  # add all required arguments

  name     = "test-${local.random_suffix}"
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

  module_enabled = false
}
