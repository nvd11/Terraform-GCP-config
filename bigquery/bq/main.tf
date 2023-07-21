data "local_file" "datasets" {
  filename = "./datasets.tf"
}

# for tables and datasets
module "datasets" {
  source     = "./datasets.tf"
  project_id = var.project_id
  region_id = var.region_id
}

