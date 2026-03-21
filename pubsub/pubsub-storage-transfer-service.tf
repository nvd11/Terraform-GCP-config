resource "google_pubsub_topic" "topic_storage_transfer_service" {
  name = "TopicSTS"
  project  = var.project_id
}


# subscriptions
resource "google_pubsub_subscription" "subscription_sts" {
  name     = "SubscriptionSTS"
  topic    = google_pubsub_topic.topic_storage_transfer_service.name
  project  = var.project_id
}
