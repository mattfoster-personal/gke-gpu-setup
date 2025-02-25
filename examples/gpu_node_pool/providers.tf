terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  credentials = file("./gcp-key.json") # Path to your credentials file
  project     = "gothic-province-450601-c2"
  region      = "southamerica-east1-c"
}
