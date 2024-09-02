# Enable BigQuery API
resource "google_project_service" "bq_api" {
  project = var.project_id
  service = "bigquery.googleapis.com"
}

module "bq" {
  source     = "./bq"
  project_id = var.project_id
  location = var.region_id
}

module "bq_ds2" {
  source     = "./bq_ds2"
  project_id = var.project_id
  location = var.region_id
}

module "bq_k8s" {
  source     = "./bq_k8s"
  project_id = var.project_id
  location = var.region_id
}

module "bq_logs" {
  source     = "./bq_logs"
  project_id = var.project_id
  location = var.region_id
  fluentd_ingress_email = var.fluentd_ingress_email
}