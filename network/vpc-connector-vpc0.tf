resource "google_vpc_access_connector" "connector" {
  name          = "vpc-con"
  network = google_compute_network.tf-vpc0.id # for the network where the connector will be created
  machine_type = "e2-micro" # machine type for the connector
  region = "europe-west2"
  ip_cidr_range = "192.168.100.0/28" # means the connector will use created vms in this range
                                     # should not overlap with the sub network's ip range
}
