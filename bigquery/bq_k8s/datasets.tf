resource "google_bigquery_dataset" "dataset_k8s" {
  dataset_id = "DSK8S"
  project   = var.project_id
  location  = var.location
}