
# tf-vpc0
# ============================================================================================================================
# create a vpc
resource "google_compute_network" "tf-vpc0" {
  project = var.project_id
  name                    = "tf-vpc0"
  auto_create_subnetworks = false
}

# create a subnet
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "tf-vpc0-subnet0" {
  name                     = "tf-vpc0-subnet0"
  ip_cidr_range            = "192.168.0.0/24" # 192.168.0.1 ~ 192.168.0.255
  region                   = var.region_id
  # only PRIVATE could allow vm creation,  the PRIVATE item is displayed as "None" in GCP console subnet creation page
  # but we cannot set purpose to "None",  if we did , the subnet will still created as purpose = PRIVATE , and next terraform plan/apply will try to recreate the subnet!
  # as it detect changes for "PRIVATE" -> "NONE"
  # gcloud compute networks subnets describe tf-vpc0-subnet0 --region=europe-west2
  purpose                  = "PRIVATE" 
  role                     = "ACTIVE"
  private_ip_google_access = "true" # to eanble the vm to access gcp products via internal network but not internet, faster and less cost!
  network                  = google_compute_network.tf-vpc0.name
}

# create a subnet
resource "google_compute_subnetwork" "tf-vpc0-subnet1" {
  name                     = "tf-vpc0-subnet1"
  ip_cidr_range            = "192.168.1.0/24" # 192.168.0.1 ~ 192.168.0.255
  region                   = var.region_id
  purpose                  = "PRIVATE"
  role                     = "ACTIVE"
  private_ip_google_access = "true"
  network                  = google_compute_network.tf-vpc0.name
}

# Create firewall rules
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "tf-vpc0-firewall" {
  name    = "tf-vpc0-firewall"
  network = google_compute_network.tf-vpc0.name

  allow {
    protocol = "icmp" # to enable ping
  }

  allow {
    protocol = "tcp"
    ports    = ["1-32767"]
  }

  # it's needed for k8s nodeport...
  # otherwise -> NodePort only responding on node where pod is running
  allow { 
    protocol = "udp" 
    ports    = ["1-32767"]
  }


  source_ranges = ["0.0.0.0/0"] # allow any external part access

  # target_tags - (Optional) A list of instance tags indicating sets of instances located in the network that may make network connections as specified in allowed[]. 
  # If no targetTags are specified, the firewall rule applies to all instances on the specified network.
  # target_tags   = [google_compute_subnetwork.tf-subnet.name] 
}


## Create Cloud Router

resource "google_compute_router" "tf-vpc0-nat-router" {
  project = var.project_id
  name    = "tf-vpc0-nat-router"
  network = google_compute_network.tf-vpc0.name
  region  = var.region_id
}

## Create Nat Gateway

resource "google_compute_router_nat" "tf-vpc0-cloud-nat" {
  name                               = "tf-vpc0-cloud-nat"
  router                             = google_compute_router.tf-vpc0-nat-router.name
  region                             = var.region_id
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}




# output
# ==========================================================================================================================================

output "tf_vpc0_name" {
  value = google_compute_network.tf-vpc0.name
}

output "tf_vpc0_subnet0_name" {
  value = google_compute_subnetwork.tf-vpc0-subnet0.name
}

output "tf_vpc0_subnet1_name" {
  value = google_compute_subnetwork.tf-vpc0-subnet1.name
}

