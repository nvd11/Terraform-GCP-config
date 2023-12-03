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

module "pubsub" {
  source     = "./pubsub"
  project_id = var.project_id
  region_id = var.region_id
}

module "bucket" {
  source     = "./bucket"
  project_id = var.project_id
  region_id = var.region_id
}

module "vm" {
  source     = "./vm"
  project_id = var.project_id
  region_id = var.region_id
  zone_id = var.zone_id
}