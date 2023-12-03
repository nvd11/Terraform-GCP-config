
# create a vpc
resource "google_compute_network" "tf-vpc" {
  project = var.project_id
  name                    = "tf-vpc"
  auto_create_subnetworks = false
}

# create a subnet
resource "google_compute_subnetwork" "tf-subnet" {
  provider = google-beta

  name          = "tf-subnet"
  ip_cidr_range = "192.168.0.0/24"
  region        = var.region_id
  purpose       = "None"
  role          = "ACTIVE"
  network       = google_compute_network.tf-vpc.id
}
