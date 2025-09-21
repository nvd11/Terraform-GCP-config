resource "google_storage_bucket" "bucket-jason-hsbc" {
  name     = "${var.project_id}-raw"
  project  = var.project_id
  location = var.region_id
}

resource "google_storage_bucket" "bucket-jason-hsbc-dataflow" {
  name     = "${var.project_id}-dataflow"
  project  = var.project_id
  location = var.region_id
}

resource "google_storage_bucket" "bucket-jason-hsbc-src" {
  name     = "${var.project_id}-src"
  project  = var.project_id
  location = var.region_id
}


resource "google_storage_bucket" "bucket-jason-hsbc-des" {
  name     = "${var.project_id}-des"
  project  = var.project_id
  location = var.region_id
}

resource "google_storage_bucket" "bucket-jason-hsbc-test" {
  name     = "${var.project_id}-test"
  project  = var.project_id
  location = var.region_id
}

resource "google_storage_bucket" "bucket-cloud-build" {
  name     = "${var.project_id}_cloudbuild"
  project  = var.project_id
  location = var.region_id
  force_destroy = true
}

# https://github.com/GoogleCloudPlatform/esp-v2/issues/148
resource "google_storage_bucket_object" "bucket-cloud-build-source" {
  name = "source/"
  content = "Not really a directory, but it's empty."
  bucket = "${google_storage_bucket.bucket-cloud-build.name}"
}

resource "google_storage_bucket_iam_binding" "bucket-cloud-build-rw" {
  bucket = google_storage_bucket.bucket-cloud-build.name
  role   = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:912156613264-compute@developer.gserviceaccount.com",
  ]
}

output "bucket-jason-hsbc-name" {
  value = google_storage_bucket.bucket-jason-hsbc.name
}
