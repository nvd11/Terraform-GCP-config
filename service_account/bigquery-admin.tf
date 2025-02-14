# create a resource for a new service account
resource "google_service_account" "service_account_bq_adm" {
  account_id   = "bq-adm"
  display_name = "service count for bigquery admin"
  project      = var.project_id
}

# define the roles for the service account
resource "google_project_iam_binding" "service_account_bq_adm" {
  project = var.project_id
  role    = "roles/bigquery.admin"

  members = [
    "serviceAccount:${google_service_account.service_account_bq_adm.email}"
  ]
}
