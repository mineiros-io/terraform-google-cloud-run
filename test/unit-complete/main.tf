module "test-sa" {
  source = "github.com/mineiros-io/terraform-google-service-account?ref=v0.1.1"

  account_id = "service-account-id-${local.random_suffix}"
}

module "test1" {
  source = "../.."

  # add all required arguments

  name     = "unit-complete-${local.random_suffix}"
  location = var.gcp_region

  autogenerate_revision_name = false

  template = {
    metadata = {
      name      = "unit-complete-meta"
      namespace = "unit-complete-ns"
      labels = {
        foo = "bar"
      }
      annotations = {
        foo = "bar"
      }
    }
    spec = {
      container_concurrency = 0
      timeout_seconds       = 100
      service_account_name  = "unit-complete-sa"
      containers = [
        {
          args    = ["/bin/sh", "-c"]
          image   = "gcr.io/cloudrun/hello:latest"
          command = ["yes"]
          env = [
            {
              name  = "env-var-unit-complete-foo"
              value = "env-var-value-foo"
            },
            {
              name = "env-var-unit-complete-bar"
              value_from = {
                secret_key_ref = {
                  key  = "latest"
                  name = "env-var-secret-ref-unit-complete"
                }
              }
            }
          ]
          ports = [
            {
              name           = "unit-complete-port"
              protocol       = "TCP"
              container_port = 42069
            },
            {
              name           = "unit-complete-port2"
              protocol       = "UDP"
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
    },
    {
      percent         = 31
      latest_revision = true
    }
  ]

  metadata = {
    namespace = "unit-complete-ns"
    labels = {
      foo = "bar"
    }
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
      annotations = {
        foo = "bar"
      }
    }
  }

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  # add all optional arguments that create additional/extended resources

  iam = [
    {
      role    = "roles/run.invoker"
      members = ["domain:example-domain"]
    },
    {
      role    = "roles/run.viewer"
      members = ["computed:computed_sa"]
    }
  ]

  # add most/all other optional arguments

  project = "example-project"
}

module "test2" {
  source = "../.."

  # add all required arguments

  name     = "unit-complete-${local.random_suffix}"
  location = var.gcp_region

  autogenerate_revision_name = true

  template = {
    metadata = {
      namespace = "unit-complete-ns"
      labels = {
        foo = "bar"
      }
      annotations = {
        foo = "bar"
      }
    }
    spec = {
      container_concurrency = 0
      timeout_seconds       = 100
      service_account_name  = "unit-complete-sa"
      containers = [
        {
          args    = ["/bin/sh", "-c"]
          image   = "gcr.io/cloudrun/hello:latest"
          command = ["yes"]
          env = [
            {
              name  = "env-var-unit-complete-foo"
              value = "env-var-value-foo"
            },
            {
              name = "env-var-unit-complete-bar"
              value_from = {
                secret_key_ref = {
                  key  = "latest"
                  name = "env-var-secret-ref-unit-complete"
                }
              }
            }
          ]
          ports = [
            {
              name           = "unit-complete-port"
              protocol       = "TCP"
              container_port = 42069
            },
            {
              name           = "unit-complete-port2"
              protocol       = "UDP"
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

    }
  ]

  metadata = {
    namespace = "unit-complete-ns"
    labels = {
      foo = "bar"
    }
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
      annotations = {
        foo = "bar"
      }
    }
  }

  # add all optional arguments that create additional/extended resources

  iam = [
    {
      role          = "roles/run.invoker"
      members       = ["domain:example-domain"]
      authoritative = false
    },
    {
      role          = "roles/run.viewer"
      members       = ["computed:computed_sa"]
      authoritative = false
    }
  ]

  # add most/all other optional arguments

  project = "example-project"
}

module "test3" {
  source = "../.."

  # add all required arguments

  name     = "unit-complete-${local.random_suffix}"
  location = var.gcp_region

  autogenerate_revision_name = false

  template = {
    metadata = {
      name      = "unit-complete-meta"
      namespace = "unit-complete-ns"
      labels = {
        foo = "bar"
      }
      annotations = {
        foo = "bar"
      }
    }
    spec = {
      container_concurrency = 0
      timeout_seconds       = 100
      service_account_name  = "unit-complete-sa"
      containers = [
        {
          args    = ["/bin/sh", "-c"]
          image   = "gcr.io/cloudrun/hello:latest"
          command = ["yes"]
          env = [
            {
              name  = "env-var-unit-complete-foo"
              value = "env-var-value-foo"
            },
            {
              name = "env-var-unit-complete-bar"
              value_from = {
                secret_key_ref = {
                  key  = "latest"
                  name = "env-var-secret-ref-unit-complete"
                }
              }
            }
          ]
          ports = [
            {
              name           = "unit-complete-port"
              protocol       = "TCP"
              container_port = 42069
            },
            {
              name           = "unit-complete-port2"
              protocol       = "UDP"
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
    },
    {
      percent         = 31
      latest_revision = true
    }
  ]

  metadata = {
    namespace = "unit-complete-ns"
    labels = {
      foo = "bar"
    }
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
      annotations = {
        foo = "bar"
      }
    }
  }

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  # add all optional arguments that create additional/extended resources
  policy_bindings = [
    {
      role    = "roles/run.admin"
      members = ["user:admin@$example-domain"]
    },
    {
      role    = "roles/run.viewer"
      members = ["user:user@$example-domain"]
      condition = {
        expression = "request.time < timestamp(\"2024-01-01T00:00:00Z\")"
        title      = "expires_after_2023_12_31"
      }
    }
  ]

  # add most/all other optional arguments

  project = "example-project"
}
