# create a resource for a new service account
resource "google_service_account" "service_account_fluentd_ingress" {
  account_id   = "fluentd-ingress"
  display_name = "service count for fluentd sidecar"
  project      = var.project_id
}

output "svc_account_fluentd_ingress_email" {
  value = google_service_account.service_account_fluentd_ingress.email
}