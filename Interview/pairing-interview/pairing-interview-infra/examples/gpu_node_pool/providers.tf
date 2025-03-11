terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
# credentials = file("/Users/matthew/k8s-admin-key.json") # Path to your credentials file
 # project     = "gothic-province-450601-c2"
  project = "ai-research-e44f"
  region      = "southamerica-east1-c"
}
