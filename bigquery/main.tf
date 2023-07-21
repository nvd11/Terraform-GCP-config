# Enable BigQuery API
resource "google_project_service" "bq_api" {
  project = var.project_id
  service = "bigquery.googleapis.com"
}

module "bq" {
  source     = "./bq"
  project_id = var.project_id
  region_id = var.region_id
}