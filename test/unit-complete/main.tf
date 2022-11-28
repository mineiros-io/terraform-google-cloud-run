module "test" {
  source = "../.."

  # add all required arguments

  name     = "unit-complete-${local.random_suffix}"
  location = "europe-west3"
  project  = local.project_id

  autogenerate_revision_name = false

  template = {
    metadata = {
      name      = "unit-complete-meta"
      namespace = "unit-complete-ns"
      lables = {
        foo = "bar"
      }
      annotations = {
        foo = "bar"
      }
    }
    spec = {
      conatiner_concurrency = 0
      timeout_seconds       = 100
      service_account_name  = "unit-complete-sa"
      containers = [
        {
          args    = ["/bin/sh", "-c"]
          image   = "gcr.io/cloudrun/hello:latest"
          command = ["yes"]
          env = {
            name  = "unit-complete"
            value = "foo"
            value_from = {
              secret_key_ref = {
                key  = "latest"
                name = "unit-complete"
              }
            }
          }
          ports = [
            {
              name           = "unit-complete-port"
              protocol       = "TCP"
              container_port = 42069
            }
          ]
          resources = {
            limits = {
              cpu    = "250m"
              memory = "1Gi"
            }
            requests = {
              cpu    = "250m"
              memory = "1Gi"
            }
          }
        }
      ]
    }
  }

  traffic = [
    {
      revision_name   = "first"
      percent         = 69
      latest_revision = false

      metadata = {
        namespace = "unit-complete-ns"
        labels = {
          foo = "bar"
        }
        generation       = 0
        resource_version = "0.0.0"
        self_link        = "path/to/self"
        uid              = "fd32528f-8020-4f04-9e5e-c89ea4f904dd"
        annotations = {
          foo = "bar"
        }
      }
      domain_mapping = {
        spec = {
          force_override   = true
          certificate_mode = "NONE"
        }
        metadata = {
          namespace = "unit-complete-ns"
          labels = {
            foo = "bar"
          }
          generation       = 0
          resource_version = "0.0.0"
          self_link        = "path/to/self"
          uid              = "fd32528f-8020-4f04-9e5e-c89ea4f904dd"
          annotations = {
            foo = "bar"
          }
        }
      }
    }
  ]

  # add all optional arguments that create additional/extended resources

  iam = [
    {
      role    = "roles/run.invoker"
      members = ["domain:example-domain"]
    }
  ]

  # add most/all other optional arguments
}

module "test1" {
  source = "../.."

  # add all required arguments

  name     = "unit-complete-${local.random_suffix}"
  location = "europe-west3"
  project  = local.project_id

  autogenerate_revision_name = true

  template = {
    metadata = {
      namespace = "unit-complete-ns"
      lables = {
        foo = "bar"
      }
      annotations = {
        foo = "bar"
      }
    }
    spec = {
      conatiner_concurrency = 0
      timeout_seconds       = 100
      service_account_name  = "unit-complete-sa"
      containers = [
        {
          args    = ["/bin/sh", "-c"]
          image   = "gcr.io/cloudrun/hello:latest"
          command = ["yes"]
          env = {
            name  = "unit-complete"
            value = "foo"
            value_from = {
              secret_key_ref = {
                key  = "latest"
                name = "unit-complete"
              }
            }
          }
          ports = [
            {
              name           = "unit-complete-port"
              protocol       = "TCP"
              container_port = 42069
            }
          ]
          resources = {
            limits = {
              cpu    = "250m"
              memory = "1Gi"
            }
            requests = {
              cpu    = "250m"
              memory = "1Gi"
            }
          }
        }
      ]
    }
  }

  traffic = [
    {
      revision_name   = "first"
      percent         = 69
      latest_revision = false

      metadata = {
        namespace = "unit-complete-ns"
        labels = {
          foo = "bar"
        }
        generation       = 0
        resource_version = "0.0.0"
        self_link        = "path/to/self"
        uid              = "fd32528f-8020-4f04-9e5e-c89ea4f904dd"
        annotations = {
          foo = "bar"
        }
      }
      domain_mapping = {
        spec = {
          force_override   = true
          certificate_mode = "NONE"
        }
        metadata = {
          namespace = "unit-complete-ns"
          labels = {
            foo = "bar"
          }
          generation       = 0
          resource_version = "0.0.0"
          self_link        = "path/to/self"
          uid              = "fd32528f-8020-4f04-9e5e-c89ea4f904dd"
          annotations = {
            foo = "bar"
          }
        }
      }
    }
  ]

  # add all optional arguments that create additional/extended resources

  iam = [
    {
      role    = "roles/run.invoker"
      members = ["domain:example-domain"]
    }
  ]

  # add most/all other optional arguments
}
