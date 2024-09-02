terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.21.0"
    }
  }
}



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
  fluentd_ingress_email = module.service_account.svc_account_fluentd_ingress_email
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

module "network" {
  source     = "./network"
  project_id = var.project_id
  region_id = var.region_id
  zone_id = var.zone_id
}

module "vm" {
  source     = "./vm"
  project_id = var.project_id
  region_id = var.region_id
  zone_id = var.zone_id
  vpc0 = module.network.tf_vpc0_name
  vpc0_subnet0 = module.network.tf_vpc0_subnet0_name
  vpc0_subnet1 = module.network.tf_vpc0_subnet1_name
  vpc1 = module.network.tf_vpc1_name
  vpc1_subnet0 = module.network.tf_vpc1_subnet0_name
}

module "storage_transfer_service_demo" {
  source     = "./sts_demo"
  project_id = var.project_id
  region_id = var.region_id
  zone_id = var.zone_id
  gcs_sa = var.gcs_sa
  sts_sa = var.sts_sa
}

module "service_account" {
  source     = "./service_account"
  project_id = var.project_id
  region_id = var.region_id
  zone_id = var.zone_id
}

module "cloudbuild" {
  source     = "./cloudbuild"
  project_id = var.project_id
  region_id = var.region_id
  zone_id = var.zone_id
}