provider "google" {
    credentials = file("/opt/apps/terraform/gcpkey.json")
    project = var.project_id
    region = "asia-east1"
    zone = "asia-east1-a"
}

module "artifact_registry" {
  source     = "./artifact_registry"
  arr_project_id = var.project_id
}
