# create a resource for a new service account
resource "google_service_account" "service_account_pubsub_bucket_adm" {
  account_id   = "pubsub-bucket-adm"
  display_name = "service count for pubsub bucket admin"
  project      = var.project_id
}

# define the roles for the service account
resource "google_project_iam_binding" "service_account_pubsub_bucket_adm" {
  project = var.project_id
  role    = "roles/pubsub.admin"

  members = [
    "serviceAccount:${google_service_account.service_account_pubsub_bucket_adm.email}"
  ]
}

resource "google_project_iam_binding" "service_account_pubsub_bucket_adm_storage" {
  project = var.project_id
  role    = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.service_account_pubsub_bucket_adm.email}"
  ]
}