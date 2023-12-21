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