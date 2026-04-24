variable "project_id" {}
variable "region_id" {}

resource "google_service_account" "autorestart_sa" {
  account_id   = "autorestart-sa"
  display_name = "SA for Auto-Restart Cloud Function"
}

resource "google_project_iam_member" "compute_admin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.autorestart_sa.email}"
}

resource "google_project_iam_member" "event_receiver" {
  project = var.project_id
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.autorestart_sa.email}"
}

resource "google_storage_bucket" "function_source_bucket" {
  name                        = "${var.project_id}-gcf-source"
  location                    = var.region_id
  uniform_bucket_level_access = true
  force_destroy               = true
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/function-source.zip"
}

resource "google_storage_bucket_object" "function_zip_obj" {
  name   = "function-source-${data.archive_file.function_zip.output_md5}.zip"
  bucket = google_storage_bucket.function_source_bucket.name
  source = data.archive_file.function_zip.output_path
}

resource "google_cloudfunctions2_function" "autorestart_fn" {
  name        = "autorestart-spot-vm"
  location    = var.region_id
  description = "Auto restart spot VM when preempted or stopped"

  build_config {
    runtime     = "python310"
    entry_point = "restart_vm"
    source {
      storage_source {
        bucket = google_storage_bucket.function_source_bucket.name
        object = google_storage_bucket_object.function_zip_obj.name
      }
    }
  }

  service_config {
    max_instance_count    = 1
    available_memory      = "256M"
    timeout_seconds       = 60
    service_account_email = google_service_account.autorestart_sa.email
  }

  event_trigger {
    trigger_region        = "global"
    event_type            = "google.cloud.audit.log.v1.written"
    service_account_email = google_service_account.autorestart_sa.email
    
    event_filters {
      attribute = "serviceName"
      value     = "compute.googleapis.com"
    }
    event_filters {
      attribute = "methodName"
      value     = "v1.compute.instances.preempted"
    }
  }
}
