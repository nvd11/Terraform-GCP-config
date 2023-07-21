resource "google_bigquery_dataset" "dataset" {
  dataset_id = "DS1"
  project   = var.project_id
  location  = var.location
}