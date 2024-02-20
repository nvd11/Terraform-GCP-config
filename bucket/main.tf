resource "google_storage_bucket" "bucket-jason-hsbc" {
  name     = "jason-hsbc-raw"
  project  = var.project_id
  location = var.region_id
}

resource "google_storage_bucket" "bucket-jason-hsbc-dataflow" {
  name     = "jason-hsbc-dataflow"
  project  = var.project_id
  location = var.region_id
}

resource "google_storage_bucket" "bucket-jason-hsbc-src" {
  name     = "jason-hsbc-src"
  project  = var.project_id
  location = var.region_id
}


resource "google_storage_bucket" "bucket-jason-hsbc-des" {
  name     = "jason-hsbc-des"
  project  = var.project_id
  location = var.region_id
}


output "bucket-jason-hsbc-name" {
  value = google_storage_bucket.bucket-jason-hsbc.name
}