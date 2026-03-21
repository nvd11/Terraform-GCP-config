
resource "google_cloudbuild_trigger" "demo_cloud_order-sonarqube-trigger" {
  name = "demo-cloud-order-sonarqube-trigger" # could not contains underscore

  location = var.region_id

  # when use github then should use trigger_template
  github {
    name = "demo_cloud_order"
    owner = "nvd11"
    push {
      branch = ".*"
      # for all branch
       
      invert_regex = false # means trigger on branch
    }
  }

  filename = "cloudbuild-sonarqube.yaml"
  # projects/jason-hsbc/serviceAccounts/terraform@jason-hsbc.iam.gserviceaccount.com
  service_account = data.google_service_account.cloudbuild_sa.id 
}

