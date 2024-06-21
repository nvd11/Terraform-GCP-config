
# difference between data and resource: data is read only, resource is read and write
data google_service_account "cloudbuild_sa" {
  project = var.project_id
  account_id = "terraform"
}


# referring https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger
resource "google_cloudbuild_trigger" "demo_cloud_user-gce-trigger" {
  name = "demo-cloud-user-gce-trigger" # could not contains underscore

  location = var.region_id

  # when use github then should use trigger_template
  github {
    name = "demo_cloud_user"
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



# referring https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudbuild_trigger
resource "google_cloudbuild_trigger" "bq-api-service-gar-trigger" {
  name = "bq-api-service-gar-trigger" # could not contains underscore

  location = var.region_id

  # when use github then should use trigger_template
  github {
    name = "gcp_bq_api"
    owner = "nvd11"
    push {
      branch = "master"
      invert_regex = false # means trigger on branch
    }
  }


  filename = "cloudbuild-gar.yaml"
  # projects/jason-hsbc/serviceAccounts/terraform@jason-hsbc.iam.gserviceaccount.com
  service_account = data.google_service_account.cloudbuild_sa.id 
}

