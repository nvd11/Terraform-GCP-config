resource "google_compute_address" "static-ip-1" {
  count = 0
  name = "static-ip-1"
  address_type = "EXTERNAL"
}

