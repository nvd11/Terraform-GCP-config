# ==============================================================================
# Variables Definition
# ==============================================================================

# The GCP Project ID where all these resources will be deployed.
# Passed down from the root module's variable.
variable "project_id" {}

# The GCP Region where the Cloud Function and its storage bucket will be hosted.
# Also passed down from the root module.
variable "region_id" {}


# ==============================================================================
# IAM & Service Account Configuration
# ==============================================================================

# Create a dedicated, least-privilege Service Account strictly for the Cloud Function.
# Following best practices, we avoid using the default Compute Engine service account.
resource "google_service_account" "autorestart_sa" {
  account_id   = "autorestart-sa"
  display_name = "SA for Auto-Restart Cloud Function"
}

# Grant the Service Account the 'Compute Instance Admin (v1)' role.
# This role contains the specific permission 'compute.instances.start' required 
# by the Python script to successfully send the API request to boot the preempted VM.
resource "google_project_iam_member" "compute_admin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.autorestart_sa.email}"
}

# Grant the Service Account the 'Eventarc Event Receiver' role.
# This is absolutely necessary for Eventarc to be able to securely invoke 
# the Cloud Function when the matching Cloud Audit Log event is detected.
resource "google_project_iam_member" "event_receiver" {
  project = var.project_id
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.autorestart_sa.email}"
}

# Grant the Service Account the 'Cloud Run Invoker' role.
# Eventarc requires this permission to invoke the Gen 2 Cloud Function (which runs on Cloud Run).
resource "google_project_iam_member" "run_invoker" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.autorestart_sa.email}"
}

# Grant the Service Account the 'Cloud Run Invoker' role explicitly on the underlying Cloud Run service.
# This solves the 401 Unauthorized issue where Eventarc fails to trigger the Gen 2 Cloud Function.
resource "google_cloud_run_service_iam_member" "function_run_invoker" {
  project  = var.project_id
  location = var.region_id
  service  = google_cloudfunctions2_function.autorestart_fn.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.autorestart_sa.email}"
}


# Get the Google project data to access the project number dynamically
data "google_project" "project" {
  project_id = var.project_id
}

# Grant the GCP Pub/Sub Service Agent the required Token Creator role.
# Eventarc relies on Pub/Sub to push events to Cloud Run (Cloud Functions Gen 2).
# The Pub/Sub agent needs this role to create OIDC tokens acting as the trigger Service Account.
resource "google_project_iam_member" "pubsub_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}


# ==============================================================================
# Cloud Storage & Source Code Packaging
# ==============================================================================

# Create a Google Cloud Storage (GCS) Bucket to hold the Cloud Function's source code.
# The name includes the project_id to ensure it meets the global uniqueness requirement.
resource "google_storage_bucket" "function_source_bucket" {
  name                        = "${var.project_id}-gcf-source"
  location                    = var.region_id
  uniform_bucket_level_access = true
  
  # force_destroy = true ensures that if we run 'terraform destroy', the bucket 
  # will be deleted even if it still contains the zip files.
  force_destroy               = true
}

# Use the 'archive_file' data source to dynamically compress the local Python code 
# directory ('src/') into a deployment-ready ZIP file on the fly during 'terraform apply'.
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/function-source.zip"
}

# Upload the dynamically generated ZIP file to the Cloud Storage bucket created above.
# We append the MD5 hash of the zip to the object name. This ensures that every time 
# the source code changes, a new object is created, forcing the Cloud Function to redeploy.
resource "google_storage_bucket_object" "function_zip_obj" {
  name   = "function-source-${data.archive_file.function_zip.output_md5}.zip"
  bucket = google_storage_bucket.function_source_bucket.name
  source = data.archive_file.function_zip.output_path
}


# ==============================================================================
# Cloud Function (v2) & Eventarc Trigger
# ==============================================================================

# Provision the 2nd Generation Cloud Function that will execute our Python script.
resource "google_cloudfunctions2_function" "autorestart_fn" {
  name        = "autorestart-spot-vm"
  location    = var.region_id
  description = "Auto restart spot VM when preempted or stopped"

  # Define how the function is built from the source code.
  build_config {
    # ========================================================================
    # HOW THE PYTHON SDK & DEPENDENCIES ARE RESOLVED:
    # 1. Terraform provisions the pure execution environment (e.g., Python 3.12).
    # 2. Terraform DOES NOT define the specific Python SDKs to be installed.
    # 3. Instead, when GCP unpacks the source code ZIP, its internal build engine 
    #    automatically detects the 'requirements.txt' file located in the root.
    # 4. It executes `pip install -r requirements.txt` before the container starts,
    #    seamlessly installing libraries like 'google-cloud-compute'.
    # This neatly decouples Infrastructure configuration from Application dependencies.
    # ========================================================================
    runtime     = "python312"          # Use the cutting-edge Python 3.12 runtime environment
    
    # ========================================================================
    # HOW GCP RESOLVES THE ENTRY POINT (Convention over Configuration):
    # 1. By default, the Google Cloud Functions Python runtime explicitly 
    #    looks for a file named exactly 'main.py' at the root of the source.
    # 2. Once 'main.py' is loaded, the runtime reads this 'entry_point' attribute.
    # 3. Under the hood, it performs the equivalent of: `from main import restart_vm`.
    # As long as our core logic is in 'main.py', GCP flawlessly discovers it.
    # ========================================================================
    entry_point = "restart_vm"         # The exact name of the Python function to execute
    
    source {
      storage_source {
        # Point the build process to the exact GCS bucket and ZIP object we uploaded.
        bucket = google_storage_bucket.function_source_bucket.name
        object = google_storage_bucket_object.function_zip_obj.name
      }
    }
  }

  # Configure the runtime environment execution parameters for the function.
  service_config {
    max_instance_count    = 1      # Cap scaling to 1 to prevent runaway costs/concurrent executions
    available_memory      = "512M" # Allocate enough memory to prevent OOM errors from the Google Cloud SDK
    timeout_seconds       = 60     # Abort the execution if it hangs for more than 60 seconds
    
    # Attach our tightly scoped, custom Service Account to this function's execution environment.
    service_account_email = google_service_account.autorestart_sa.email
  }

  # This block automatically creates and binds an Eventarc trigger to the Cloud Function.
  event_trigger {
    # Audit logs are global resources, so the trigger listening to them must also be global.
    trigger_region        = "global"
    
    # We are explicitly listening for a newly written Cloud Audit Log entry.
    event_type            = "google.cloud.audit.log.v1.written"
    
    # Identify the Service Account that Eventarc will use to trigger the function.
    service_account_email = google_service_account.autorestart_sa.email
    
    # Filter #1: We only care about events originating from the Compute Engine API.
    event_filters {
      attribute = "serviceName"
      value     = "compute.googleapis.com"
    }
    
    # Filter #2: We strictly filter for the exact API method invoked when a Spot VM is preempted.
    # This ensures the function isn't needlessly triggered by other random Compute Engine logs.
    event_filters {
      attribute = "methodName"
      value     = "compute.instances.preempted"
    }
  }
}
