resource "google_project_service" "artifact_registry" {
  project = var.arr_project_id
  service = "artifactregistry.googleapis.com"
}

resource "google_artifact_registry_repository" "repository" {
  format = "docker"
  repository_id    = "my-docker-repo"
  location = var.region_id
  project = var.arr_project_id
}

