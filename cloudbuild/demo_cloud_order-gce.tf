# referring https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger
resource "google_cloudbuild_trigger" "demo_cloud_order-gce-trigger" {
  name = "demo-cloud-order-gce-trigger" # could not contains underscore

  location = var.region_id

  # when use github then should use trigger_template
  github {
    name = "demo_cloud_order"
    owner = "nvd11"
    push {
      branch = "main"
      invert_regex = false # means trigger on branch
    }
  }

  substitutions = {
    _VM_HOST = "tf-vpc0-subnet0-vm0"
    _APP_ENV = "prod"
  }

  filename = "cloudbuild-gce.yaml"
  # projects/jason-hsbc/serviceAccounts/terraform@jason-hsbc.iam.gserviceaccount.com
  service_account = data.google_service_account.cloudbuild_sa.id 
}
