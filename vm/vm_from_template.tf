# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_from_template
# this vm is created based on an instance template
resource "google_compute_instance_from_template" "tf-vpc0-subnet0-vm20" {
  name         = "tf-vpc0-subnet0-vm20"
  project      = var.project_id
  zone         = var.zone_id
  allow_stopping_for_update = true

  # from a instance template
  source_instance_template = "https://www.googleapis.com/compute/v1/projects/jason-hsbc/global/instanceTemplates/e2-small-tomcat"
}

resource "google_compute_instance_from_template" "tf-vpc0-subnet0-vm21" {
  name         = "tf-vpc0-subnet0-vm21"
  project      = var.project_id
  zone         = var.zone_id

  # from a instance template
  source_instance_template = google_compute_instance_template.vm-template-vpc0-subnet0-e2-small-tomcat.self_link_unique
}

# The custom properties of vm_from_template could overwrite the pre-defined properties in instance template
resource "google_compute_instance_from_template" "tf-vpc0-subnet1-vm1" {
  name         = "tf-vpc0-subnet1-vm1"
  project      = var.project_id
  zone         = var.zone_id

  network_interface {
    network =  "tf-vpc0"
    subnetwork =  "tf-vpc0-subnet1"  # here the subnet property will overwrite the setting in instance template
  }
  # from a instance template
  source_instance_template = google_compute_instance_template.vm-template-vpc0-subnet0-e2-small-tomcat.self_link_unique
}

# for docker server
resource "google_compute_instance_from_template" "tf-vpc0-subnet0-vm22" {
  name         = "tf-vpc0-subnet0-vm22"
  project      = var.project_id
  zone         = var.zone_id

  # from a instance template
  source_instance_template = google_compute_instance_template.vm-template-vpc0-subnet0-docker-server.self_link_unique
}