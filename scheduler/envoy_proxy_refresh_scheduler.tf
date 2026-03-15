# Data source to find the existing Cloud Build trigger by its name.
data "google_cloudbuild_trigger" "refresh_trigger" {
  project    = var.project_id
  location   = var.region
  trigger_id = "envoy-proxy-refresh-trigger"
}

# Data source to find the existing service account for the scheduler.
data "google_service_account" "scheduler_sa" {
  account_id = "terraform"
  project    = var.project_id
}

# This resource creates a Cloud Scheduler job to run the trigger daily.
resource "google_cloud_scheduler_job" "refresh_envoy_mig_daily" {
  name        = "refresh-envoy-mig-daily"
  description = "Daily job to refresh the Envoy MIG by running a Cloud Build trigger."
  schedule    = "0 3 * * *" # Runs every day at 3:00 AM UTC
  time_zone   = "Etc/UTC"
  project     = var.project_id
  region      = var.region

  http_target {
    http_method = "POST"
    
    # The URI is constructed dynamically using the data source above.
    uri = "https://cloudbuild.googleapis.com/v1/${data.google_cloudbuild_trigger.refresh_trigger.id}:run"
    
    # The request body required by the Cloud Build API
    body = base64encode("{\"source\": {\"projectId\": \"${var.project_id}\", \"repoName\": \"envoy-config\", \"branchName\": \"main\"}}")
    
    # Headers required for the API call
    headers = {
      "Content-Type" = "application/json"
    }

    # Use the service account found by the data source to authenticate.
    oauth_token {
      service_account_email = data.google_service_account.scheduler_sa.email
    }
  }
}
