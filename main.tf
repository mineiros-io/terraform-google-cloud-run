resource "google_cloud_run_service" "service" {
  count = var.module_enabled ? 1 : 0

  depends_on = [var.module_depends_on]

  name                       = var.name
  location                   = var.location
  project                    = var.project
  autogenerate_revision_name = var.autogenerate_revision_name

  dynamic "template" {
    for_each = var.template != null ? [var.template] : []

    content {
      dynamic "metadata" {
        for_each = try([template.value.metadata], [])

        content {
          name             = try(metadata.value.name, null)
          namespace        = try(metadata.value.namespace, null)
          labels           = try(metadata.value.labels, {})
          generation       = try(metadata.value.generation, null)
          resource_version = try(metadata.value.resource_version, null)
          self_link        = try(metadata.value.self_link, null)
          uid              = try(metadata.value.uid, null)
          annotations      = try(metadata.value.annotations, null)
        }
      }

      spec {
        container_concurrency = try(template.value.spec.container_concurrency, null)
        timeout_seconds       = try(template.value.spec.timeout_seconds, null)
        service_account_name  = try(template.value.spec.service_account_name, null)
        serving_state         = try(template.value.spec.serving_state, null)

        dynamic "containers" {
          for_each = template.value.spec.containers

          content {
            args    = try(containers.value.args, null)
            image   = containers.value.image
            command = try(containers.value.command, null)

            dynamic "env" {
              for_each = try(containers.value.env, [])

              content {
                name  = try(env.value.name, null)
                value = try(env.value.value, null)
              }
            }

            dynamic "ports" {
              for_each = try(containers.value.ports, [])

              content {
                name           = try(ports.value.name, null)
                protocol       = try(ports.value.protocol, "TCP")
                container_port = ports.value.container_port
              }
            }

            dynamic "resources" {
              for_each = try(containers.value.resources, [])

              content {
                limits   = try(resources.value.limits, null)
                requests = try(resources.value.requests, resources.value.limits, null)
              }
            }
          }
        }
      }
    }
  }

  dynamic "traffic" {
    for_each = var.traffic

    content {
      revision_name   = try(traffic.value.revision_name, null)
      percent         = traffic.value.percent
      latest_revision = try(traffic.value.latest_revision, null)
    }
  }

  dynamic "metadata" {
    for_each = var.metadata != null ? [var.metadata] : []

    content {
      namespace        = try(metadata.value.namespace, null)
      labels           = try(metadata.value.labels, {})
      generation       = try(metadata.value.generation, null)
      resource_version = try(metadata.value.resource_version, null)
      self_link        = try(metadata.value.self_link, null)
      uid              = try(metadata.value.uid, null)
      annotations      = try(metadata.value.annotations, null)
    }
  }

  timeouts {
    create = try(var.module_timeouts.google_cloud_run_service.create, "6m")
    update = try(var.module_timeouts.google_cloud_run_service.update, "15m")
    delete = try(var.module_timeouts.google_cloud_run_service.delete, "4m")
  }
}

resource "google_cloud_run_domain_mapping" "domain_mapping" {
  count = var.module_enabled && var.domain_mapping != null ? 1 : 0

  name     = var.domain_mapping.name
  location = var.domain_mapping.location
  project  = var.project

  spec {
    route_name       = google_cloud_run_service.service[0].name
    force_override   = try(var.domain_mapping.spec.force_override, null)
    certificate_mode = try(var.domain_mapping.spec.certificate_mode, "AUTOMATIC")
  }

  metadata {
    namespace        = var.domain_mapping.metadata.namespace
    labels           = try(var.domain_mapping.metadata.labels, {})
    generation       = try(var.domain_mapping.metadata.generation, null)
    resource_version = try(var.domain_mapping.metadata.resource_version, null)
    self_link        = try(var.domain_mapping.metadata.self_link, null)
    uid              = try(var.domain_mapping.metadata.uid, null)
    annotations      = try(var.domain_mapping.metadata.annotations, null)
  }

  timeouts {
    create = try(var.module_timeouts.google_cloud_run_domain_mapping.create, "6m")
    delete = try(var.module_timeouts.google_cloud_run_domain_mapping.delete, "4m")
  }
}
