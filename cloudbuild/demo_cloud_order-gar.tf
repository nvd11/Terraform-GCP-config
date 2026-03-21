
resource "google_cloudbuild_trigger" "demo_cloud_order-gar-trigger" {
  name = "demo-cloud-order-gar-trigger" # could not contains underscore

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

  filename = "cloudbuild-gar.yaml"
  # projects/jason-hsbc/serviceAccounts/terraform@jason-hsbc.iam.gserviceaccount.com
  service_account = data.google_service_account.cloudbuild_sa.id 
}


resource "google_cloudbuild_trigger" "demo_cloud_order-gar-trigger-configmap-test" {
  name = "demo-cloud-order-gar-trigger-configmap-test" # could not contains underscore

  location = var.region_id

  # when use github then should use trigger_template
  github {
    name = "demo_cloud_order"
    owner = "nvd11"
    push {
      branch = "configmap-test"
      invert_regex = false # means trigger on branch
    }
  }

  filename = "cloudbuild-gar.yaml"
  # projects/jason-hsbc/serviceAccounts/terraform@jason-hsbc.iam.gserviceaccount.com
  service_account = data.google_service_account.cloudbuild_sa.id 
}

resource "google_cloudbuild_trigger" "demo_cloud_order-gar-trigger-storage" {
  name = "demo-cloud-order-gar-trigger-storage" # could not contains underscore

  location = var.region_id

  # when use github then should use trigger_template
  github {
    name = "demo_cloud_order"
    owner = "nvd11"
    push {
      branch = "storage"
      invert_regex = false # means trigger on branch
    }
  }

  filename = "cloudbuild-gar.yaml"
  # projects/jason-hsbc/serviceAccounts/terraform@jason-hsbc.iam.gserviceaccount.com
  service_account = data.google_service_account.cloudbuild_sa.id
}
