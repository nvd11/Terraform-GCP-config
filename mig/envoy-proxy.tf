# use mig module# This data source looks up the existing 'vm-common' service account.
# It does NOT create a new one. This is the standard way to reference
# resources that are managed outside of this Terraform configuration.
data "google_service_account" "vm_common" {
  account_id = "vm-common"
}

module "my_new_mig" {
  source                = "github.com/nvd11/terraform-mig?ref=1.0.6"
  
  name                  = "my-envoy"
  zone                  = var.zone_id
  machine_type          = "e2-medium"
  source_image          = "projects/jason-hsbc/global/images/packer-gce-envoy"
  subnetwork            = var.vpc0_subnet0_self_link
  service_account_email = data.google_service_account.vm_common.email
  target_size           = 1
  spot                  = true
}
