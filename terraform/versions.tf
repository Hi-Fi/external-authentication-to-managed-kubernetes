

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.20.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "4.20.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.5.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.11.0"
    }
  }

  required_version = ">= 0.14"
}
