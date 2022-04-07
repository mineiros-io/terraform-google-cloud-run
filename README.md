[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-google-cloud-run)

[![Build Status](https://github.com/mineiros-io/terraform-google-cloud-run/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-google-cloud-run/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-google-cloud-run.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-google-cloud-run/releases)
[![Terraform Version](https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Google Provider Version](https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-google/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-google-cloud-run

A [Terraform](https://www.terraform.io) module for creating and managing
[Google Cloud Run](https://cloud.google.com/run/docs/) with optional
[Custom Domain Mapping](https://cloud.google.com/run/docs/mapping-custom-domains).

**_This module supports Terraform version 1
and is compatible with the Terraform Google Provider version 4._**

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Main Resource Configuration](#main-resource-configuration)
  - [Extended Resource Configuration](#extended-resource-configuration)
  - [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [Google Documentation](#google-documentation)
  - [Terraform GCP Provider Documentation](#terraform-gcp-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following Terraform resources

- `google_cloud_run_service`
- `google_cloud_run_domain_mapping`

and supports additional features of the following modules:

- [mineiros-io/terraform-google-cloud-run-iam](https://github.com/mineiros-io/terraform-google-cloud-run-iam)

## Getting Started

Most common usage of the module:

```hcl
module "terraform-google-cloud-run" {
  source = "git@github.com:mineiros-io/terraform-google-cloud-run.git?ref=v0.0.2"

  name     = "example-name"
  location = "us-central1"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Main Resource Configuration

- [**`name`**](#var-name): *(**Required** `string`)*<a name="var-name"></a>

  Name must be unique within a namespace, within a Cloud Run region.
  Is required when creating resources. Name is primarily intended for
  creation idempotence and configuration definition. Cannot be updated.

- [**`location`**](#var-location): *(**Required** `string`)*<a name="var-location"></a>

  The location of the cloud run instance. eg `us-central1`.

- [**`project`**](#var-project): *(Optional `string`)*<a name="var-project"></a>

  The ID of the project in which the resource belongs. If it is not 
  provided, the provider project is used.

- [**`autogenerate_revision_name`**](#var-autogenerate_revision_name): *(Optional `bool`)*<a name="var-autogenerate_revision_name"></a>

  If set to `true`, the revision name (`template.metadata.name`) will be
  omitted and autogenerated by Cloud Run. This cannot be set to true
  while `template.metadata.name` is also set. (For legacy support, if
  `template.metadata.name` is unset in state while this field is set to
  `false`, the revision name will still autogenerate.).

- [**`template`**](#var-template): *(Optional `object(template)`)*<a name="var-template"></a>

  A template holds the latest specification for the Revision to be
  stamped out. The template references the container image, and may also
  include labels and annotations that should be attached to the
  Revision. To correlate a Revision, and/or to force a Revision to be
  created when the spec doesn't otherwise change, a nonce label may be
  provided in the template metadata.

  Default is `{}`.

  The `template` object accepts the following attributes:

  - [**`metadata`**](#attr-template-metadata): *(Optional `object(metadata)`)*<a name="attr-template-metadata"></a>

    Optional metadata for this Revision, including labels and
    annotations. Name will be generated by the Configuration. To set
    minimum instances for this revision, use the
    `autoscaling.knative.dev/minScale` annotation key. To set maximum
    instances for this revision, use the 
    `autoscaling.knative.dev/maxScale` annotation key. To set Cloud SQL
    connections for the revision, use the
    `run.googleapis.com/cloudsql-instances` annotation key.

    Default is `{}`.

    The `metadata` object accepts the following attributes:

    - [**`name`**](#attr-template-metadata-name): *(Optional `string`)*<a name="attr-template-metadata-name"></a>

      Name must be unique within a namespace, within a Cloud Run region.
      Is required when creating resources. Name is primarily intended
      for creation idempotence and configuration definition. Cannot be
      updated. More info:
      http://kubernetes.io/docs/user-guide/identifiers#names

    - [**`namespace`**](#attr-template-metadata-namespace): *(Optional `string`)*<a name="attr-template-metadata-namespace"></a>

      In Cloud Run the namespace must be equal to either the project ID
      or project number. It will default to the resource's project.

    - [**`labels`**](#attr-template-metadata-labels): *(Optional `map(string)`)*<a name="attr-template-metadata-labels"></a>

      Map of string keys and values that can be used to organize and
      categorize (scope and select) objects. May match selectors of
      replication controllers and routes. More info:
      http://kubernetes.io/docs/user-guide/labels

    - [**`generation`**](#attr-template-metadata-generation): *(Optional `number`)*<a name="attr-template-metadata-generation"></a>

      A sequence number representing a specific generation of the
      desired state.

    - [**`resource_version`**](#attr-template-metadata-resource_version): *(Optional `string`)*<a name="attr-template-metadata-resource_version"></a>

      An opaque value that represents the internal version of this
      object that can be used by clients to determine when objects have
      changed. May be used for optimistic concurrency, change detection,
      and the watch operation on a resource or set of resources. They
      may only be valid for a particular resource or set of resources.
      More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#concurrency-control-and-consistency

    - [**`self_link`**](#attr-template-metadata-self_link): *(Optional `string`)*<a name="attr-template-metadata-self_link"></a>

      SelfLink is a URL representing this object.

    - [**`uid`**](#attr-template-metadata-uid): *(Optional `string`)*<a name="attr-template-metadata-uid"></a>

      UID is a unique id generated by the server on successful creation
      of a resource and is not allowed to change on PUT operations. More
      info: http://kubernetes.io/docs/user-guide/identifiers#uids

    - [**`annotations`**](#attr-template-metadata-annotations): *(Optional `map(string)`)*<a name="attr-template-metadata-annotations"></a>

      Annotations is a key value map stored with a resource that may be
      set by external tools to store and retrieve arbitrary metadata.
      More info: http://kubernetes.io/docs/user-guide/annotations Note:
      The Cloud Run API may add additional annotations that were not
      provided in your config. If terraform plan shows a diff where a
      server-side annotation is added, you can add it to your config or
      apply the `lifecycle.ignore_changes` rule to the
      `metadata.0.annotations` field.

  - [**`spec`**](#attr-template-spec): *(Optional `object(spec)`)*<a name="attr-template-spec"></a>

    RevisionSpec holds the desired state of the Revision (from the
    client).

    Default is `{}`.

    The `spec` object accepts the following attributes:

    - [**`container_concurrency`**](#attr-template-spec-container_concurrency): *(Optional `number`)*<a name="attr-template-spec-container_concurrency"></a>

      ContainerConcurrency specifies the maximum allowed in-flight
      (concurrent) requests per container of the Revision. Values are:

      - 0 thread-safe, the system should manage the max concurrency.
        This is the default value.
      - 1 not-thread-safe. Single concurrency
      - 2-N thread-safe, max concurrency of N

    - [**`timeout_seconds`**](#attr-template-spec-timeout_seconds): *(Optional `number`)*<a name="attr-template-spec-timeout_seconds"></a>

      TimeoutSeconds holds the max duration the instance is allowed for
      responding to a request.

    - [**`service_account_name`**](#attr-template-spec-service_account_name): *(Optional `string`)*<a name="attr-template-spec-service_account_name"></a>

      Email address of the IAM service account associated with the
      revision of the service. The service account represents the
      identity of the running revision, and determines what permissions
      the revision has. If not provided, the revision will use the
      project's default service account.

    - [**`serving_state`**](#attr-template-spec-serving_state): *(Optional `string`)*<a name="attr-template-spec-serving_state"></a>

      ServingState holds a value describing the state the resources are
      in for this Revision. It is expected that the system will
      manipulate this based on routability and load.

    - [**`containers`**](#attr-template-spec-containers): *(Optional `list(container)`)*<a name="attr-template-spec-containers"></a>

      Container defines the unit of execution for this Revision. In the
      context of a Revision, we disallow a number of the fields of this
      Container, including: name, ports, and volumeMounts. The runtime
      contract is documented here: https://github.com/knative/serving/blob/master/docs/runtime-contract.md

      Default is `[]`.

      Each `container` object in the list accepts the following attributes:

      - [**`args`**](#attr-template-spec-containers-args): *(Optional `list(string)`)*<a name="attr-template-spec-containers-args"></a>

        Arguments to the entrypoint. The docker image's CMD is used if
        this is not provided. Variable references `$(VAR_NAME)` are
        expanded using the container's environment. If a variable cannot
        be resolved, the reference in the input string will be unchanged.
        The `$(VAR_NAME)` syntax can be escaped with a double `$$`, ie:
        `$$(VAR_NAME)`. Escaped references will never be expanded,
        regardless of whether the variable exists or not. More info:
        https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell

      - [**`image`**](#attr-template-spec-containers-image): *(**Required** `string`)*<a name="attr-template-spec-containers-image"></a>

        Docker image name. This is most often a reference to a container
        located in the container registry, such as
        `gcr.io/cloudrun/helloMore` info:
        https://kubernetes.io/docs/concepts/containers/images

      - [**`command`**](#attr-template-spec-containers-command): *(Optional `string`)*<a name="attr-template-spec-containers-command"></a>

        Entrypoint array. Not executed within a shell. The docker
        image's ENTRYPOINT is used if this is not provided. Variable
        references `$(VAR_NAME)` are expanded using the container's
        environment. If a variable cannot be resolved, the reference in
        the input string will be unchanged. The `$(VAR_NAME)` syntax can
        be escaped with a double `$$`, ie: `$$(VAR_NAME)`. Escaped
        references will never be expanded, regardless of whether the
        variable exists or not. More info:
        https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell

      - [**`env`**](#attr-template-spec-containers-env): *(Optional `object(env)`)*<a name="attr-template-spec-containers-env"></a>

        List of environment variables to set in the container.

        Default is `{}`.

        The `env` object accepts the following attributes:

        - [**`name`**](#attr-template-spec-containers-env-name): *(Optional `string`)*<a name="attr-template-spec-containers-env-name"></a>

          Name of the environment variable.

        - [**`value`**](#attr-template-spec-containers-env-value): *(Optional `string`)*<a name="attr-template-spec-containers-env-value"></a>

          Variable references `$(VAR_NAME)` are expanded using the
          previous defined environment variables in the container and
          any route environment variables. If a variable cannot be
          resolved, the reference in the input string will be unchanged.
          The `$(VAR_NAME)` syntax can be escaped with a double `$$`, 
          ie: `$$(VAR_NAME)`. Escaped references will never be expanded,
          regardless of whether the variable exists or not.

      - [**`ports`**](#attr-template-spec-containers-ports): *(Optional `list(port)`)*<a name="attr-template-spec-containers-ports"></a>

        List of open ports in the container. More Info:
        https://cloud.google.com/run/docs/reference/rest/v1/RevisionSpec#ContainerPort

        Default is `[]`.

        Each `port` object in the list accepts the following attributes:

        - [**`name`**](#attr-template-spec-containers-ports-name): *(Optional `string`)*<a name="attr-template-spec-containers-ports-name"></a>

          Name of the port.

        - [**`protocol`**](#attr-template-spec-containers-ports-protocol): *(Optional `string`)*<a name="attr-template-spec-containers-ports-protocol"></a>

          Protocol used on port.

          Default is `"TCP"`.

        - [**`container_port`**](#attr-template-spec-containers-ports-container_port): *(**Required** `number`)*<a name="attr-template-spec-containers-ports-container_port"></a>

          Port number.

      - [**`resources`**](#attr-template-spec-containers-resources): *(Optional `object(resource)`)*<a name="attr-template-spec-containers-resources"></a>

        Compute Resources required by this container. Used to set values
        such as max memory More info:
        https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#requests-and-limits

        Default is `{}`.

        The `resource` object accepts the following attributes:

        - [**`limits`**](#attr-template-spec-containers-resources-limits): *(Optional `map(string)`)*<a name="attr-template-spec-containers-resources-limits"></a>

          Limits describes the maximum amount of compute resources
          allowed. The values of the map is string form of the
          'quantity' k8s type:
          https://github.com/kubernetes/kubernetes/blob/master/staging/src/k8s.io/apimachinery/pkg/api/resource/quantity.go

        - [**`requests`**](#attr-template-spec-containers-resources-requests): *(Optional `map(string)`)*<a name="attr-template-spec-containers-resources-requests"></a>

          Requests describes the minimum amount of compute resources
          required. If Requests is omitted for a container, it defaults
          to Limits if that is explicitly specified, otherwise to an
          implementation-defined value. The values of the map is string
          form of the 'quantity' k8s type:
          https://github.com/kubernetes/kubernetes/blob/master/staging/src/k8s.io/apimachinery/pkg/api/resource/quantity.go

- [**`traffic`**](#var-traffic): *(Optional `list(traffic)`)*<a name="var-traffic"></a>

  A list of traffic specifies how to distribute traffic over a
  collection of Knative Revisions and Configurations Structure.

  Default is `[]`.

  Each `traffic` object in the list accepts the following attributes:

  - [**`revision_name`**](#attr-traffic-revision_name): *(Optional `string`)*<a name="attr-traffic-revision_name"></a>

    RevisionName of a specific revision to which to send this portion of
    traffic.

  - [**`percent`**](#attr-traffic-percent): *(**Required** `number`)*<a name="attr-traffic-percent"></a>

    Percent specifies percent of the traffic to this Revision or
    Configuration.

  - [**`latest_revision`**](#attr-traffic-latest_revision): *(Optional `bool`)*<a name="attr-traffic-latest_revision"></a>

    LatestRevision may be optionally provided to indicate that the
    latest ready Revision of the Configuration should be used for this
    traffic target. When provided LatestRevision must be `true` if
    `RevisionName` is empty; it must be `false` when `RevisionName` is
    non-empty.

- [**`metadata`**](#var-metadata): *(Optional `object(metadata)`)*<a name="var-metadata"></a>

  Optional metadata for this Revision, including labels and
  annotations. Name will be generated by the Configuration. To set
  minimum instances for this revision, use the
  `autoscaling.knative.dev/minScale` annotation key. To set maximum
  instances for this revision, use the 
  `autoscaling.knative.dev/maxScale` annotation key. To set Cloud SQL
  connections for the revision, use the
  `run.googleapis.com/cloudsql-instances` annotation key.

  Default is `{}`.

  The `metadata` object accepts the following attributes:

  - [**`namespace`**](#attr-metadata-namespace): *(Optional `string`)*<a name="attr-metadata-namespace"></a>

    In Cloud Run the namespace must be equal to either the project ID
    or project number. It will default to the resource's project.

  - [**`labels`**](#attr-metadata-labels): *(Optional `map(string)`)*<a name="attr-metadata-labels"></a>

    Map of string keys and values that can be used to organize and
    categorize (scope and select) objects. May match selectors of
    replication controllers and routes. More info:
    http://kubernetes.io/docs/user-guide/labels

  - [**`generation`**](#attr-metadata-generation): *(Optional `number`)*<a name="attr-metadata-generation"></a>

    A sequence number representing a specific generation of the
    desired state.

  - [**`resource_version`**](#attr-metadata-resource_version): *(Optional `string`)*<a name="attr-metadata-resource_version"></a>

    An opaque value that represents the internal version of this
    object that can be used by clients to determine when objects have
    changed. May be used for optimistic concurrency, change detection,
    and the watch operation on a resource or set of resources. They
    may only be valid for a particular resource or set of resources.
    More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#concurrency-control-and-consistency

  - [**`self_link`**](#attr-metadata-self_link): *(Optional `string`)*<a name="attr-metadata-self_link"></a>

    SelfLink is a URL representing this object.

  - [**`uid`**](#attr-metadata-uid): *(Optional `string`)*<a name="attr-metadata-uid"></a>

    UID is a unique id generated by the server on successful creation
    of a resource and is not allowed to change on PUT operations. More
    info: http://kubernetes.io/docs/user-guide/identifiers#uids

  - [**`annotations`**](#attr-metadata-annotations): *(Optional `map(string)`)*<a name="attr-metadata-annotations"></a>

    Annotations is a key value map stored with a resource that may be
    set by external tools to store and retrieve arbitrary metadata.
    More info: http://kubernetes.io/docs/user-guide/annotations Note:
    The Cloud Run API may add additional annotations that were not
    provided in your config. If terraform plan shows a diff where a
    server-side annotation is added, you can add it to your config or
    apply the `lifecycle.ignore_changes` rule to the
    `metadata.0.annotations` field.

- [**`domain_mapping`**](#var-domain_mapping): *(Optional `object(domain_mapping)`)*<a name="var-domain_mapping"></a>

  An Object that holds the state and status of a user's domain mapping.

  The `domain_mapping` object accepts the following attributes:

  - [**`spec`**](#attr-domain_mapping-spec): *(Optional `object(spec)`)*<a name="attr-domain_mapping-spec"></a>

    RevisionSpec holds the desired state of the Revision (from the
    client).

    Default is `{}`.

    The `spec` object accepts the following attributes:

    - [**`force_override`**](#attr-domain_mapping-spec-force_override): *(Optional `bool`)*<a name="attr-domain_mapping-spec-force_override"></a>

      If set, the mapping will override any mapping set before this spec
      was set. It is recommended that the user leaves this empty to
      receive an error warning about a potential conflict and only set
      it once the respective UI has given such a warning.

    - [**`certificate_mode`**](#attr-domain_mapping-spec-certificate_mode): *(Optional `string`)*<a name="attr-domain_mapping-spec-certificate_mode"></a>

      The mode of the certificate. Possible values are `NONE` and 
      `AUTOMATIC`.

      Default is `"AUTOMATIC"`.

  - [**`metadata`**](#attr-domain_mapping-metadata): *(Optional `object(metadata)`)*<a name="attr-domain_mapping-metadata"></a>

    Optional metadata for this Revision, including labels and
    annotations. Name will be generated by the Configuration. To set
    minimum instances for this revision, use the
    `autoscaling.knative.dev/minScale` annotation key. To set maximum
    instances for this revision, use the 
    `autoscaling.knative.dev/maxScale` annotation key. To set Cloud SQL
    connections for the revision, use the
    `run.googleapis.com/cloudsql-instances` annotation key.

    Default is `{}`.

    The `metadata` object accepts the following attributes:

    - [**`namespace`**](#attr-domain_mapping-metadata-namespace): *(Optional `string`)*<a name="attr-domain_mapping-metadata-namespace"></a>

      In Cloud Run the namespace must be equal to either the project ID
      or project number. It will default to the resource's project.

    - [**`labels`**](#attr-domain_mapping-metadata-labels): *(Optional `map(string)`)*<a name="attr-domain_mapping-metadata-labels"></a>

      Map of string keys and values that can be used to organize and
      categorize (scope and select) objects. May match selectors of
      replication controllers and routes. More info:
      http://kubernetes.io/docs/user-guide/labels

    - [**`generation`**](#attr-domain_mapping-metadata-generation): *(Optional `number`)*<a name="attr-domain_mapping-metadata-generation"></a>

      A sequence number representing a specific generation of the
      desired state.

    - [**`resource_version`**](#attr-domain_mapping-metadata-resource_version): *(Optional `string`)*<a name="attr-domain_mapping-metadata-resource_version"></a>

      An opaque value that represents the internal version of this
      object that can be used by clients to determine when objects have
      changed. May be used for optimistic concurrency, change detection,
      and the watch operation on a resource or set of resources. They
      may only be valid for a particular resource or set of resources.
      More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#concurrency-control-and-consistency

    - [**`self_link`**](#attr-domain_mapping-metadata-self_link): *(Optional `string`)*<a name="attr-domain_mapping-metadata-self_link"></a>

      SelfLink is a URL representing this object.

    - [**`uid`**](#attr-domain_mapping-metadata-uid): *(Optional `string`)*<a name="attr-domain_mapping-metadata-uid"></a>

      UID is a unique id generated by the server on successful creation
      of a resource and is not allowed to change on PUT operations. More
      info: http://kubernetes.io/docs/user-guide/identifiers#uids

    - [**`annotations`**](#attr-domain_mapping-metadata-annotations): *(Optional `map(string)`)*<a name="attr-domain_mapping-metadata-annotations"></a>

      Annotations is a key value map stored with a resource that may be
      set by external tools to store and retrieve arbitrary metadata.
      More info: http://kubernetes.io/docs/user-guide/annotations Note:
      The Cloud Run API may add additional annotations that were not
      provided in your config. If terraform plan shows a diff where a
      server-side annotation is added, you can add it to your config or
      apply the `lifecycle.ignore_changes` rule to the
      `metadata.0.annotations` field.

### Extended Resource Configuration

- [**`iam`**](#var-iam): *(Optional `list(iam)`)*<a name="var-iam"></a>

  A list of IAM access to apply to the created secret.

  Default is `[]`.

  Each `iam` object in the list accepts the following attributes:

  - [**`role`**](#attr-iam-role): *(Optional `string`)*<a name="attr-iam-role"></a>

    The role that should be applied. Note that custom roles must be of
    the format
    `[projects|organizations]/{parent-name}/roles/{role-name}`.

  - [**`members`**](#attr-iam-members): *(Optional `set(string)`)*<a name="attr-iam-members"></a>

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

  - [**`authoritative`**](#attr-iam-authoritative): *(Optional `bool`)*<a name="attr-iam-authoritative"></a>

    Whether to exclusively set (authoritative mode) or add
    (non-authoritative/additive mode) members to the role.

    Default is `true`.

- [**`policy_bindings`**](#var-policy_bindings): *(Optional `list(policy_binding)`)*<a name="var-policy_bindings"></a>

  A list of IAM policy bindings.

  Example:

  ```hcl
  policy_bindings = [{
    role    = "roles/viewer"
    members = ["user:member@example.com"]
  }]
  ```

  Each `policy_binding` object in the list accepts the following attributes:

  - [**`role`**](#attr-policy_bindings-role): *(**Required** `string`)*<a name="attr-policy_bindings-role"></a>

    The role that should be applied.

  - [**`members`**](#attr-policy_bindings-members): *(Optional `set(string)`)*<a name="attr-policy_bindings-members"></a>

    Identities that will be granted the privilege in `role`.

    Default is `var.members`.

  - [**`condition`**](#attr-policy_bindings-condition): *(Optional `object(condition)`)*<a name="attr-policy_bindings-condition"></a>

    An IAM Condition for a given binding.

    Example:

    ```hcl
    condition = {
      expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
      title      = "expires_after_2021_12_31"
    }
    ```

    The `condition` object accepts the following attributes:

    - [**`expression`**](#attr-policy_bindings-condition-expression): *(**Required** `string`)*<a name="attr-policy_bindings-condition-expression"></a>

      Textual representation of an expression in Common Expression
      Language syntax.

    - [**`title`**](#attr-policy_bindings-condition-title): *(**Required** `string`)*<a name="attr-policy_bindings-condition-title"></a>

      A title for the expression, i.e. a short string describing its
      purpose.

    - [**`description`**](#attr-policy_bindings-condition-description): *(Optional `string`)*<a name="attr-policy_bindings-condition-description"></a>

      An optional description of the expression. This is a longer text
      which describes the expression, e.g. when hovered over it in a
      UI.

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_timeouts`**](#var-module_timeouts): *(Optional `object(module_timeouts)`)*<a name="var-module_timeouts"></a>

  A map of timeout objects that is keyed by Terraform resource name
  defining timeouts for `create`, `update` and `delete` Terraform operations.

  Supported resources are: `google_cloud_run_service`, `google_cloud_run_domain_mapping`

  Default is `{}`.

  Example:

  ```hcl
  module_timeouts = {
    null_resource = {
      create = "4m"
      update = "4m"
      delete = "4m"
    }
  }
  ```

  The `module_timeouts` object accepts the following attributes:

  - [**`create`**](#attr-module_timeouts-create): *(Optional `string`)*<a name="attr-module_timeouts-create"></a>

    Timeout for create operations.

    Default is `"6m"`.

  - [**`update`**](#attr-module_timeouts-update): *(Optional `string`)*<a name="attr-module_timeouts-update"></a>

    Timeout for update operations.

    Default is `"15m"`.

  - [**`delete`**](#attr-module_timeouts-delete): *(Optional `string`)*<a name="attr-module_timeouts-delete"></a>

    Timeout for delete operations.

    Default is `"4m"`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies.
  Any object can be _assigned_ to this list to define a hidden external dependency.

  Default is `[]`.

  Example:

  ```hcl
  module_depends_on = [
    null_resource.name
  ]
  ```

## Module Outputs

The following attributes are exported in the outputs of the module:

- [**`iam`**](#output-iam): *(`list(iam)`)*<a name="output-iam"></a>

  The iam resource objects that define the access to the secret.

- [**`service`**](#output-service): *(`object(service)`)*<a name="output-service"></a>

  All `google_cloud_run_service` resource attributes.

- [**`domain_mapping`**](#output-domain_mapping): *(`object(domain_mapping)`)*<a name="output-domain_mapping"></a>

  All `google_cloud_run_domain_mapping` resource attributes.

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

## External Documentation

### Google Documentation

- Cloud Run - https://cloud.google.com/run/docs/
- Mapping Custom Domains - https://cloud.google.com/run/docs/mapping-custom-domains

### Terraform GCP Provider Documentation

- Run Services - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service
- Domain Mapping - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_domain_mapping

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-google-cloud-run
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://mineiros.io/slack
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-google-cloud-run/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-google-cloud-run/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-google-cloud-run/issues
[license]: https://github.com/mineiros-io/terraform-google-cloud-run/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-google-cloud-run/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-google-cloud-run/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-google-cloud-run/blob/main/CONTRIBUTING.md
