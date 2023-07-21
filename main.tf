provider "google" {
    project = var.project_id
    region = var.region_id
    zone = var.zone_id
}

module "artifact_registry" {
  source     = "./artifact_registry"
  arr_project_id = var.project_id
  region_id = var.region_id
}

module "bigquery" {
  source     = "./bigquery"
  project_id = var.project_id
  region_id = var.region_id
}