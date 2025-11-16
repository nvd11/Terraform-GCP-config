
resource "google_cloudbuild_trigger" "envoy-proxy-refresh-trigger" {
  name = "envoy-proxy-refresh-trigger" # could not contains underscore

  location = var.region_id

  # when use github then should use trigger_template
  github {
    name = "envoy-config"
    owner = "nvd11"
    push {
      branch = "main"
      invert_regex = false # means trigger on branch
    }
  }

  filename = "cloudbuild_refresh_envoy_proxy.yaml"
  # projects/jason-hsbc/serviceAccounts/terraform@jason-hsbc.iam.gserviceaccount.com
  service_account = data.google_service_account.cloudbuild_sa.id 
}
 
