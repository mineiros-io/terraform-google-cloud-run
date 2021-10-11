# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "(Required) Name must be unique within a namespace, within a Cloud Run region. Is required when creating resources. Name is primarily intended for creation idempotence and configuration definition. Cannot be updated."
  type        = string
}

variable "location" {
  description = "(Required) The location of the cloud run instance. eg us-central1."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "project" {
  description = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
  default     = null
}

variable "autogenerate_revision_name" {
  description = "(Optional) If set to true, the revision name (template.metadata.name) will be omitted and autogenerated by Cloud Run. This cannot be set to true while template.metadata.name is also set. (For legacy support, if template.metadata.name is unset in state while this field is set to false, the revision name will still autogenerate.)."
  type        = bool
  default     = null
}

variable "template" {
  description = "(Optional) A template holds the latest specification for the Revision to be stamped out. The template references the container image, and may also include labels and annotations that should be attached to the Revision. To correlate a Revision, and/or to force a Revision to be created when the spec doesn't otherwise change, a nonce label may be provided in the template metadata."
  type        = any
  default     = null
}

variable "traffic" {
  description = "(Optional) A list of traffic specifies how to distribute traffic over a collection of Knative Revisions and Configurations Structure."
  type        = any
  default     = []
}

variable "metadata" {
  description = "(Optional) A Metadata associated with this Service, including name, namespace, labels, and annotations."
  type        = any
  default     = null
}

variable "domain_mapping" {
  description = "(Optional) An Object that holds the state and status of a user's domain mapping."
  type        = any
  default     = null
}

variable "module_timeouts" {
  description = "(Optional) An Object that specifies how long certain operations (per resource type) are allowed to take before being considered to have failed."
  type        = any
  default     = {}
}

## IAM

variable "iam" {
  description = "(Optional) A list of IAM access to apply to the created secret."
  type        = any
  default     = []
}

variable "policy_bindings" {
  description = "(Optional) A list of IAM policy bindings to apply to the created secret."
  type        = any
  default     = null
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is 'true'."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is '[]'."
  default     = []
}
