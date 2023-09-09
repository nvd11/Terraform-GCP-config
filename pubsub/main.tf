resource "google_pubsub_topic" "topic_a" {
  name = "TopicA"
  project  = var.project_id
}


# subscriptions
resource "google_pubsub_subscription" "subscription_a1" {
  name     = "SubscriptionA1"
  topic    = google_pubsub_topic.topic_a.name
  project  = var.project_id
}

resource "google_pubsub_subscription" "subscription_a2" {
  name     = "SubscriptionA2"
  topic    = google_pubsub_topic.topic_a.name
  project  = var.project_id
}