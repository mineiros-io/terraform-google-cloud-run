terraform {
  required_version = ">= 0.14.0, < 2.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.75, < 5.0"
    }
  }
}
