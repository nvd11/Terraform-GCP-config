resource "google_cloudbuild_trigger" "terraform_repo_trigger" {
    name = "terraform-gcp-config-trigger"
    description = "Auto-trigger Terraform apply when code is merged to master"

    location = var.region_id

    github {
        name = "Terraform-GCP-config"
        owner = "nvd11"
        push {
            branch = "master"
            invert_regex = false # means trigger on the specified branch
        }
    }

    filename = "cloudbuild.yaml"
    service_account = data.google_service_account.cloudbuild_sa.id
}
