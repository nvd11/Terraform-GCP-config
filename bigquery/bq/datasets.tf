resource "google_bigquery_dataset" "dataset1" {
  dataset_id = "DS1"
  project   = var.project_id
  location  = var.location
}