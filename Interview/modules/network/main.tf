# Create the VPC network
resource "google_compute_network" "gke_network" {
  name                    = "gke-network"   # ✅ Unique network name
  auto_create_subnetworks = false           # ✅ We create our own subnets
}

resource "google_compute_subnetwork" "gke_subnet" {
  name          = "gke-subnet"
  region        = "southamerica-east1"
  network       = google_compute_network.gke_network.id
  ip_cidr_range = "10.10.0.0/16"  # Change this if needed

  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = "10.20.0.0/16"  # Pods CIDR
  }

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.30.0.0/16"  # Services CIDR
  }
}
