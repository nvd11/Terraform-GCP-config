resource "google_storage_bucket" "jason_keys_bucket" {
  name          = "${var.project_id}-keys-bucket"
  location      = var.region_id
  force_destroy = true

  uniform_bucket_level_access = true
}
