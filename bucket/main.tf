resource "google_storage_bucket" "bucket-jason-hsbc" {
  name     = "jason-hsbc-raw"
  project  = var.project_id
  location = var.region_id
}

output "bucket-jason-hsbc-name" {
  value = google_storage_bucket.bucket-jason-hsbc.name
}