
# create a vpc
resource "google_compute_network" "tf-vpc" {
  project = var.project_id
  name                    = "tf-vpc"
  auto_create_subnetworks = false
}

# create a subnet
resource "google_compute_subnetwork" "tf-subnet" {
  name          = "tf-subnet"
  ip_cidr_range = "192.168.0.0/24"
  region        = var.region_id
  purpose       = "None"
  role          = "ACTIVE"
  network       = google_compute_network.tf-vpc.id
}

# Create firewall rules
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "tf-firewall" {
  name    = "tf-firewall"
  network = google_compute_network.tf-vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8080", "80", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"] # allow any external part access

  # target_tags - (Optional) A list of instance tags indicating sets of instances located in the network that may make network connections as specified in allowed[]. 
  # If no targetTags are specified, the firewall rule applies to all instances on the specified network.
  # target_tags   = [google_compute_subnetwork.tf-subnet.name] 
}