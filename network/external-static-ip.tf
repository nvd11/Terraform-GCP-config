resource "google_compute_address" "static-ip-1" {
  count = 0
  name = "static-ip-1"
  address_type = "EXTERNAL"
}

resource "google_compute_address" "static-ip-envoy-proxy" {
  count = 1
  name = "static-ip-envoy-proxy"
  address_type = "EXTERNAL"
}

