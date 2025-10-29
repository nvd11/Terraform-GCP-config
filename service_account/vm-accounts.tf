# create a resource for a new service account
resource "google_service_account" "vm1-acc" {
  project = var.project_id
  account_id   = "vm1-sa"
  display_name = "VM 1 Service Account"
}


# create a resource for a new service account
resource "google_service_account" "vm2-acc" {
  project = var.project_id
  account_id   = "vm2-sa"
  display_name = "VM 2 Service Account"
}
