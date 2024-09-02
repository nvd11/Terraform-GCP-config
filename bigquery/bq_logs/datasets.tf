resource "google_bigquery_dataset" "dataset_logs" {
  dataset_id = "LOGS"
  project   = var.project_id
  location  = var.location
  # depends_on = [google_service_account.service_account_fluentd-ingress]
}

resource "google_bigquery_dataset_access" "dataset_logs_access" {
  dataset_id = google_bigquery_dataset.dataset_logs.dataset_id
  project    = google_bigquery_dataset.dataset_logs.project
  role       = "roles/bigquery.dataOwner"
  
  # 将此替换为您要授予访问权限的 Service Account
  user_by_email = var.fluentd_ingress_email
}