resource "google_vpc_access_connector" "connector" {
  name          = "vpc-con"
  network = google_compute_network.tf-vpc0.id
  machine_type = "e2-micro"
  region = "europe-west2"
  ip_cidr_range = "192.168.100.0/28"
}
