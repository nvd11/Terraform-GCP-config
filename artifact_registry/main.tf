resource "google_project_service" "artifact_registry" {
  project = var.arr_project_id
  service = "artifactregistry.googleapis.com"
}
