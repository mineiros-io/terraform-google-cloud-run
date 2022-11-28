header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-cloud-run"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-cloud-run/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-cloud-run/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-cloud-run.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-cloud-run/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-cloud-run"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module for creating and managing
    [Google Cloud Run](https://cloud.google.com/run/docs/) with optional
    [Custom Domain Mapping](https://cloud.google.com/run/docs/mapping-custom-domains).

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 4._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      This module implements the following Terraform resources

      - `google_cloud_run_service`
      - `google_cloud_run_domain_mapping`

      and supports additional features of the following modules:

      - [mineiros-io/terraform-google-cloud-run-iam](https://github.com/mineiros-io/terraform-google-cloud-run-iam)
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most common usage of the module:

      ```hcl
      module "terraform-google-cloud-run" {
        source = "github.com/mineiros-io/terraform-google-cloud-run?ref=v0.1.0"

        name     = "example-name"
        location = "us-central1"

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
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      variable "name" {
        required    = true
        type        = string
        description = <<-END
          Name must be unique within a namespace, within a Cloud Run region.
          Is required when creating resources. Name is primarily intended for
          creation idempotence and configuration definition. Cannot be updated.
        END
      }

      variable "location" {
        required    = true
        type        = string
        description = <<-END
          The location of the cloud run instance. eg `us-central1`.
        END
      }

      variable "project" {
        type        = string
        description = <<-END
          The ID of the project in which the resource belongs. If it is not
          provided, the provider project is used.
        END
      }

      variable "autogenerate_revision_name" {
        type        = bool
        description = <<-END
          If set to `true`, the revision name (`template.metadata.name`) will be
          omitted and autogenerated by Cloud Run. This cannot be set to true
          while `template.metadata.name` is also set. (For legacy support, if
          `template.metadata.name` is unset in state while this field is set to
          `false`, the revision name will still autogenerate.).
        END
      }

      variable "template" {
        type        = object(template)
        default     = {}
        description = <<-END
          A template holds the latest specification for the Revision to be
          stamped out. The template references the container image, and may also
          include labels and annotations that should be attached to the
          Revision. To correlate a Revision, and/or to force a Revision to be
          created when the spec doesn't otherwise change, a nonce label may be
          provided in the template metadata.
        END

        attribute "metadata" {
          type        = object(metadata)
          default     = {}
          description = <<-END
            Optional metadata for this Revision, including labels and
            annotations. Name will be generated by the Configuration. To set
            minimum instances for this revision, use the
            `autoscaling.knative.dev/minScale` annotation key. To set maximum
            instances for this revision, use the
            `autoscaling.knative.dev/maxScale` annotation key. To set Cloud SQL
            connections for the revision, use the
            `run.googleapis.com/cloudsql-instances` annotation key.
          END

          attribute "name" {
            type        = string
            description = <<-END
              Name must be unique within a namespace, within a Cloud Run region.
              Is required when creating resources. Name is primarily intended
              for creation idempotence and configuration definition. Cannot be
              updated. More info:
              http://kubernetes.io/docs/user-guide/identifiers#names
            END
          }

          attribute "namespace" {
            type        = string
            description = <<-END
              In Cloud Run the namespace must be equal to either the project ID
              or project number. It will default to the resource's project.
            END
          }

          attribute "labels" {
            type        = map(string)
            description = <<-END
              Map of string keys and values that can be used to organize and
              categorize (scope and select) objects. May match selectors of
              replication controllers and routes. More info:
              http://kubernetes.io/docs/user-guide/labels
            END
          }

          attribute "annotations" {
            type        = map(string)
            description = <<-END
              Annotations is a key value map stored with a resource that may be
              set by external tools to store and retrieve arbitrary metadata.
              More info: http://kubernetes.io/docs/user-guide/annotations Note:
              The Cloud Run API may add additional annotations that were not
              provided in your config. If terraform plan shows a diff where a
              server-side annotation is added, you can add it to your config or
              apply the `lifecycle.ignore_changes` rule to the
              `metadata.0.annotations` field.
            END
          }
        }

        attribute "spec" {
          required    = true
          type        = object(spec)
          description = <<-END
            RevisionSpec holds the desired state of the Revision (from the
            client).
          END

          attribute "container_concurrency" {
            type        = number
            description = <<-END
              ContainerConcurrency specifies the maximum allowed in-flight
              (concurrent) requests per container of the Revision. Values are:

              - 0 thread-safe, the system should manage the max concurrency.
                This is the default value.
              - 1 not-thread-safe. Single concurrency
              - 2-N thread-safe, max concurrency of N
            END
          }

          attribute "timeout_seconds" {
            type        = number
            description = <<-END
              TimeoutSeconds holds the max duration the instance is allowed for
              responding to a request.
            END
          }

          attribute "service_account_name" {
            type        = string
            description = <<-END
              Email address of the IAM service account associated with the
              revision of the service. The service account represents the
              identity of the running revision, and determines what permissions
              the revision has. If not provided, the revision will use the
              project's default service account.
            END
          }

          attribute "containers" {
            required    = true
            type        = list(container)
            description = <<-END
              Container defines the unit of execution for this Revision. In the
              context of a Revision, we disallow a number of the fields of this
              Container, including: name, ports, and volumeMounts. The runtime
              contract is documented here: https://github.com/knative/serving/blob/master/docs/runtime-contract.md
            END

            attribute "args" {
              type        = list(string)
              description = <<-END
                Arguments to the entrypoint. The docker image's CMD is used if
                this is not provided. Variable references `$(VAR_NAME)` are
                expanded using the container's environment. If a variable cannot
                be resolved, the reference in the input string will be unchanged.
                The `$(VAR_NAME)` syntax can be escaped with a double `$$`, ie:
                `$$(VAR_NAME)`. Escaped references will never be expanded,
                regardless of whether the variable exists or not. More info:
                https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
              END
            }

            attribute "image" {
              required    = true
              type        = string
              description = <<-END
                Docker image name. This is most often a reference to a container
                located in the container registry, such as
                `gcr.io/cloudrun/helloMore` info:
                https://kubernetes.io/docs/concepts/containers/images
              END
            }

            attribute "command" {
              type        = list(string)
              description = <<-END
                Entrypoint array. Not executed within a shell. The docker
                image's ENTRYPOINT is used if this is not provided. Variable
                references `$(VAR_NAME)` are expanded using the container's
                environment. If a variable cannot be resolved, the reference in
                the input string will be unchanged. The `$(VAR_NAME)` syntax can
                be escaped with a double `$$`, ie: `$$(VAR_NAME)`. Escaped
                references will never be expanded, regardless of whether the
                variable exists or not. More info:
                https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
              END
            }

            attribute "env" {
              type        = object(env)
              default     = {}
              description = <<-END
                List of environment variables to set in the container.
              END

              attribute "name" {
                type        = string
                description = <<-END
                  Name of the environment variable.
                END
              }

              attribute "value" {
                type        = string
                description = <<-END
                  Variable references `$(VAR_NAME)` are expanded using the
                  previous defined environment variables in the container and
                  any route environment variables. If a variable cannot be
                  resolved, the reference in the input string will be unchanged.
                  The `$(VAR_NAME)` syntax can be escaped with a double `$$`,
                  ie: `$$(VAR_NAME)`. Escaped references will never be expanded,
                  regardless of whether the variable exists or not.
                END
              }

              attribute "value_from" {
                type        = object(value_from)
                description = <<-END
                  Source for the environment variable's value.
                  Only supports `secret_key_ref`.
                END

                attribute "secret_key_ref" {
                  type        = object(secret_key_ref)
                  required    = true
                  description = <<-END
                    Selects a key (version) of a secret in Secret Manager.
                  END

                  attribute "key" {
                    type        = string
                    description = <<-END
                      A Cloud Secret Manager secret version.
                      Must be `"latest"` for the latest version or an integer for a specific version.
                    END
                  }

                  attribute "name" {
                    type        = string
                    description = <<-END
                      The name of the secret in Cloud Secret Manager.
                      By default, the secret is assumed to be in the same project.
                      If the secret is in another project, you must define an alias.
                      You set the in this field, and create an annotation with the following structure
                      `"run.googleapis.com/secrets" = ":projects//secrets/"`.
                      If multiple alias definitions are needed, they must be separated by commas in the annotation field.
                    END
                  }
                }
              }
            }

            attribute "ports" {
              type        = list(port)
              default     = []
              description = <<-END
                List of open ports in the container. More Info:
                https://cloud.google.com/run/docs/reference/rest/v1/RevisionSpec#ContainerPort
              END

              attribute "name" {
                type        = string
                description = <<-END
                  Name of the port.
                END
              }

              attribute "protocol" {
                type        = string
                description = <<-END
                  Protocol used on port.
                END
              }

              attribute "container_port" {
                required    = true
                type        = number
                description = <<-END
                  Port number.
                END
              }
            }

            attribute "resources" {
              type        = object(resource)
              default     = {}
              description = <<-END
                Compute Resources required by this container. Used to set values
                such as max memory More info:
                https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits
              END

              attribute "limits" {
                type        = map(string)
                description = <<-END
                  Limits describes the maximum amount of compute resources
                  allowed. The values of the map is string form of the
                  'quantity' k8s type:
                  https://github.com/kubernetes/kubernetes/blob/master/staging/src/k8s.io/apimachinery/pkg/api/resource/quantity.go
                END
              }

              attribute "requests" {
                type        = map(string)
                description = <<-END
                  Requests describes the minimum amount of compute resources
                  required. If Requests is omitted for a container, it defaults
                  to Limits if that is explicitly specified, otherwise to an
                  implementation-defined value. The values of the map is string
                  form of the 'quantity' k8s type:
                  https://github.com/kubernetes/kubernetes/blob/master/staging/src/k8s.io/apimachinery/pkg/api/resource/quantity.go
                END
              }
            }
          }
        }
      }

      variable "traffic" {
        type        = list(traffic)
        default     = []
        description = <<-END
          A list of traffic specifies how to distribute traffic over a
          collection of Knative Revisions and Configurations Structure.
        END

        attribute "revision_name" {
          type        = string
          description = <<-END
            RevisionName of a specific revision to which to send this portion of
            traffic.
          END
        }

        attribute "percent" {
          required    = true
          type        = number
          description = <<-END
            Percent specifies percent of the traffic to this Revision or
            Configuration.
          END
        }

        attribute "latest_revision" {
          type        = bool
          description = <<-END
            LatestRevision may be optionally provided to indicate that the
            latest ready Revision of the Configuration should be used for this
            traffic target. When provided LatestRevision must be `true` if
            `RevisionName` is empty; it must be `false` when `RevisionName` is
            non-empty.
          END
        }
      }

      variable "metadata" {
        type        = object(metadata)
        default     = {}
        description = <<-END
          Optional metadata for this Revision, including labels and
          annotations. Name will be generated by the Configuration. To set
          minimum instances for this revision, use the
          `autoscaling.knative.dev/minScale` annotation key. To set maximum
          instances for this revision, use the
          `autoscaling.knative.dev/maxScale` annotation key. To set Cloud SQL
          connections for the revision, use the
          `run.googleapis.com/cloudsql-instances` annotation key.
        END

        attribute "namespace" {
          type        = string
          description = <<-END
            In Cloud Run the namespace must be equal to either the project ID
            or project number. It will default to the resource's project.
          END
        }

        attribute "labels" {
          type        = map(string)
          description = <<-END
            Map of string keys and values that can be used to organize and
            categorize (scope and select) objects. May match selectors of
            replication controllers and routes. More info:
            http://kubernetes.io/docs/user-guide/labels
          END
        }

        attribute "generation" {
          type        = number
          description = <<-END
            A sequence number representing a specific generation of the
            desired state.
          END
        }

        attribute "resource_version" {
          type        = string
          description = <<-END
            An opaque value that represents the internal version of this
            object that can be used by clients to determine when objects have
            changed. May be used for optimistic concurrency, change detection,
            and the watch operation on a resource or set of resources. They
            may only be valid for a particular resource or set of resources.
            More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#concurrency-control-and-consistency
          END
        }

        attribute "self_link" {
          type        = string
          description = <<-END
            SelfLink is a URL representing this object.
          END
        }

        attribute "uid" {
          type        = string
          description = <<-END
            UID is a unique id generated by the server on successful creation
            of a resource and is not allowed to change on PUT operations. More
            info: http://kubernetes.io/docs/user-guide/identifiers#uids
          END
        }

        attribute "annotations" {
          type        = map(string)
          description = <<-END
            Annotations is a key value map stored with a resource that may be
            set by external tools to store and retrieve arbitrary metadata.
            More info: http://kubernetes.io/docs/user-guide/annotations Note:
            The Cloud Run API may add additional annotations that were not
            provided in your config. If terraform plan shows a diff where a
            server-side annotation is added, you can add it to your config or
            apply the `lifecycle.ignore_changes` rule to the
            `metadata.0.annotations` field.
          END
        }
      }

      variable "domain_mapping" {
        type        = object(domain_mapping)
        description = <<-END
          An Object that holds the state and status of a user's domain mapping.
        END

        attribute "spec" {
          type        = object(spec)
          default     = {}
          description = <<-END
            RevisionSpec holds the desired state of the Revision (from the
            client).
          END

          attribute "force_override" {
            type        = bool
            description = <<-END
              If set, the mapping will override any mapping set before this spec
              was set. It is recommended that the user leaves this empty to
              receive an error warning about a potential conflict and only set
              it once the respective UI has given such a warning.
            END
          }

          attribute "certificate_mode" {
            type        = string
            default     = "AUTOMATIC"
            description = <<-END
              The mode of the certificate. Possible values are `NONE` and
              `AUTOMATIC`.
            END
          }
        }

        attribute "metadata" {
          type        = object(metadata)
          default     = {}
          description = <<-END
            Optional metadata for this Revision, including labels and
            annotations. Name will be generated by the Configuration. To set
            minimum instances for this revision, use the
            `autoscaling.knative.dev/minScale` annotation key. To set maximum
            instances for this revision, use the
            `autoscaling.knative.dev/maxScale` annotation key. To set Cloud SQL
            connections for the revision, use the
            `run.googleapis.com/cloudsql-instances` annotation key.
          END

          attribute "namespace" {
            type        = string
            description = <<-END
              In Cloud Run the namespace must be equal to either the project ID
              or project number. It will default to the resource's project.
            END
          }

          attribute "labels" {
            type        = map(string)
            description = <<-END
              Map of string keys and values that can be used to organize and
              categorize (scope and select) objects. May match selectors of
              replication controllers and routes. More info:
              http://kubernetes.io/docs/user-guide/labels
            END
          }

          attribute "generation" {
            type        = number
            description = <<-END
              A sequence number representing a specific generation of the
              desired state.
            END
          }

          attribute "resource_version" {
            type        = string
            description = <<-END
              An opaque value that represents the internal version of this
              object that can be used by clients to determine when objects have
              changed. May be used for optimistic concurrency, change detection,
              and the watch operation on a resource or set of resources. They
              may only be valid for a particular resource or set of resources.
              More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#concurrency-control-and-consistency
            END
          }

          attribute "self_link" {
            type        = string
            description = <<-END
              SelfLink is a URL representing this object.
            END
          }

          attribute "uid" {
            type        = string
            description = <<-END
              UID is a unique id generated by the server on successful creation
              of a resource and is not allowed to change on PUT operations. More
              info: http://kubernetes.io/docs/user-guide/identifiers#uids
            END
          }

          attribute "annotations" {
            type        = map(string)
            description = <<-END
              Annotations is a key value map stored with a resource that may be
              set by external tools to store and retrieve arbitrary metadata.
              More info: http://kubernetes.io/docs/user-guide/annotations Note:
              The Cloud Run API may add additional annotations that were not
              provided in your config. If terraform plan shows a diff where a
              server-side annotation is added, you can add it to your config or
              apply the `lifecycle.ignore_changes` rule to the
              `metadata.0.annotations` field.
            END
          }
        }
      }
    }

    section {
      title = "Extended Resource Configuration"

      variable "iam" {
        type        = list(iam)
        default     = []
        description = <<-END
          A list of IAM access to apply to the created secret.
        END

        attribute "role" {
          type        = string
          description = <<-END
            The role that should be applied. Note that custom roles must be of
            the format
            `[projects|organizations]/{parent-name}/roles/{role-name}`.
          END
        }

        attribute "members" {
          type        = set(string)
          description = <<-END
            Identities that will be granted the privilege in role. Each entry
            can have one of the following values:
            - `allUsers`: A special identifier that represents anyone who is on
               the internet; with or without a Google account.
            - `allAuthenticatedUsers`: A special identifier that represents
               anyone who is authenticated with a Google account or a service
               account.
            - `user:{emailid}`: An email address that represents a specific
               Google account. For example, alice@gmail.com or joe@example.com.
            - `serviceAccount:{emailid}`: An email address that represents
               a service account. For example,
               `my-other-app@appspot.gserviceaccount.com`.
            - `group:{emailid}`: An email address that represents a Google
               group. For example, `admins@example.com`.
            - `domain:{domain}`: A G Suite domain (primary, instead of alias)
               name that represents all the users of that domain. For example,
              google.com or example.com.
            - `projectOwner:projectid`: Owners of the given project. For
               example, `projectOwner:my-example-project`
            - `projectEditor:projectid`: Editors of the given project.
               For example, `projectEditor:my-example-project`
            - `projectViewer:projectid`: Viewers of the given project.
               For example, `projectViewer:my-example-project`
        END
        }

        attribute "authoritative" {
          type        = bool
          default     = true
          description = <<-END
            Whether to exclusively set (authoritative mode) or add
            (non-authoritative/additive mode) members to the role.
          END
        }
      }

      variable "policy_bindings" {
        type           = list(policy_binding)
        description    = <<-END
          A list of IAM policy bindings.
        END
        readme_example = <<-END
          policy_bindings = [{
            role    = "roles/viewer"
            members = ["user:member@example.com"]
          }]
        END

        attribute "role" {
          required    = true
          type        = string
          description = <<-END
            The role that should be applied.
          END
        }

        attribute "members" {
          type        = set(string)
          default     = var.members
          description = <<-END
            Identities that will be granted the privilege in `role`.
          END
        }

        attribute "condition" {
          type           = object(condition)
          description    = <<-END
            An IAM Condition for a given binding.
          END
          readme_example = <<-END
            condition = {
              expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
              title      = "expires_after_2021_12_31"
            }
          END

          attribute "expression" {
            required    = true
            type        = string
            description = <<-END
              Textual representation of an expression in Common Expression
              Language syntax.
            END
          }

          attribute "title" {
            required    = true
            type        = string
            description = <<-END
              A title for the expression, i.e. a short string describing its
              purpose.
            END
          }

          attribute "description" {
            type        = string
            description = <<-END
              An optional description of the expression. This is a longer text
              which describes the expression, e.g. when hovered over it in a
              UI.
            END
          }
        }
      }
    }

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_timeouts" {
        type           = object(module_timeouts)
        default        = {}
        description    = <<-END
          A map of timeout objects that is keyed by Terraform resource name
          defining timeouts for `create`, `update` and `delete` Terraform operations.

          Supported resources are: `google_cloud_run_service`, `google_cloud_run_domain_mapping`
        END
        readme_example = <<-END
          module_timeouts = {
            null_resource = {
              create = "4m"
              update = "4m"
              delete = "4m"
            }
          }
        END

        attribute "create" {
          type        = string
          default     = "6m"
          description = <<-END
            Timeout for create operations.
          END
        }

        attribute "update" {
          type        = string
          default     = "15m"
          description = <<-END
            Timeout for update operations.
          END
        }

        attribute "delete" {
          type        = string
          default     = "4m"
          description = <<-END
            Timeout for delete operations.
          END
        }
      }

      variable "module_depends_on" {
        type           = list(dependency)
        description    = <<-END
          A list of dependencies.
          Any object can be _assigned_ to this list to define a hidden external dependency.
        END
        default        = []
        readme_example = <<-END
          module_depends_on = [
            null_resource.name
          ]
        END
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "iam" {
      type        = list(iam)
      description = <<-END
        The iam resource objects that define the access to the secret.
      END
    }

    output "service" {
      type        = object(service)
      description = <<-END
        All `google_cloud_run_service` resource attributes.
      END
    }

    output "domain_mapping" {
      type        = object(domain_mapping)
      description = <<-END
        All `google_cloud_run_domain_mapping` resource attributes.
      END
    }

    output "module_enabled" {
      type        = bool
      description = <<-END
        Whether this module is enabled.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation"
      content = <<-END
        - Cloud Run - https://cloud.google.com/run/docs/
        - Mapping Custom Domains - https://cloud.google.com/run/docs/mapping-custom-domains
      END
    }

    section {
      title   = "Terraform GCP Provider Documentation"
      content = <<-END
        - Run Services - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service
        - Domain Mapping - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_domain_mapping
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-cloud-run"
  }
  ref "hello@mineiros.io" {
    value = " mailto:hello@mineiros.io"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "aws" {
    value = "https://aws.amazon.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-run/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-run/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-run/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-run/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-run/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-run/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-cloud-run/blob/main/CONTRIBUTING.md"
  }
}
