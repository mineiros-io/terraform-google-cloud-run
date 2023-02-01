module "test" {
  source = "../.."

  # add only required arguments and no optional arguments

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
}
