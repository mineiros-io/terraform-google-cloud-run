module "terraform-google-cloud-run" {
  source = "github.com/mineiros-io/terraform-google-cloud-run?ref=v0.1.0"

  name     = "mineiros-cloud-run-example"
  location = "europe-north1"
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
