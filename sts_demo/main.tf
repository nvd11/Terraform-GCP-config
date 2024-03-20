// define src bucket
resource "google_storage_bucket" "bucket-jason-hsbc-demo-src" {
  name     = "jason-hsbc-demo-src"
  project  = var.project_id
  location = var.region_id
}


//define target bucket
resource "google_storage_bucket" "bucket-jason-hsbc-demo-target" {
  name     = "jason-hsbc-demo-target"
  project  = var.project_id
  location = var.region_id
}


//define a pubsub topic
resource "google_pubsub_topic" "topic_sts_demo" {
  name = "topic-sts-demo"
  project  = var.project_id
}


//define a pubsub subscription
resource "google_pubsub_subscription" "subscription_sts_demo" {
  name     = "subscription-sts-demo"
  topic    = google_pubsub_topic.topic_sts_demo.name
  project  = var.project_id
}


//resource "google_service_account" "sa-sts-demo" {
//  account_id   = "sa-sts-demo"
//  display_name = "Service Account for storage transfer service demo"
//}

resource "google_pubsub_topic_iam_binding" "topic_sts_demo_binding" {
  topic   = google_pubsub_topic.topic_sts_demo.id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${var.gcs_sa}"]
  //members = ["serviceAccount:${google_service_account.sa-sts-demo.email}","serviceAccount:${var.gcs_sa}"]
}

resource "google_pubsub_subscription_iam_binding" "subscription_sts_demo_binding" {
  subscription = google_pubsub_subscription.subscription_sts_demo.name
  role         = "roles/editor"
  members = ["serviceAccount:${var.sts_sa}"]
  
}


resource "google_storage_bucket_iam_binding" "bucket-jason-hsbc-demo-target-binding" {
  bucket = google_storage_bucket.bucket-jason-hsbc-demo-target.name
  role = "roles/storage.admin"
  members = ["serviceAccount:${var.sts_sa}"]
}

resource "google_storage_bucket_iam_binding" "bucket-jason-hsbc-demo-src-binding" {
  bucket = google_storage_bucket.bucket-jason-hsbc-demo-src.name
  role = "roles/storage.admin"
  members = ["serviceAccount:${var.sts_sa}"]
}

// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_notification.html
// define a bucket notification
resource "google_storage_notification" "notification" {
  bucket         = google_storage_bucket.bucket-jason-hsbc-demo-src.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.topic_sts_demo.id
  event_types    = ["OBJECT_FINALIZE", "OBJECT_METADATA_UPDATE"]
  custom_attributes = {
    new-attribute = "new-attribute-value"
  }
  depends_on = [google_pubsub_topic_iam_binding.topic_sts_demo_binding]
}

// https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_transfer_job.html

resource "google_storage_transfer_job" "transfer-job-sts-demo" {
  description = "transfer-job-sts-demo"
  project     = var.project_id
  transfer_spec {

    transfer_options {
      overwrite_objects_already_existing_in_sink = true
      overwrite_when = "ALWAYS"
      delete_objects_from_source_after_transfer = true 
    }

    gcs_data_source {
      bucket_name = google_storage_bucket.bucket-jason-hsbc-demo-src.name

    }
    gcs_data_sink {
      bucket_name = google_storage_bucket.bucket-jason-hsbc-demo-target.name
    }
   
  }

  event_stream {
      name =  format("projects/%s/subscriptions/%s", var.project_id, google_pubsub_subscription.subscription_sts_demo.name)
  }

  
  depends_on = [google_storage_notification.notification, 
                google_pubsub_subscription_iam_binding.subscription_sts_demo_binding,
                google_storage_bucket_iam_binding.bucket-jason-hsbc-demo-target-binding,
                google_storage_bucket_iam_binding.bucket-jason-hsbc-demo-src-binding]
}