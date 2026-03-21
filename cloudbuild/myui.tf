resource "google_cloudbuild_trigger" "myui-cloudbuild-trigger" {
    name = "myui-cloudbuild-trigger"

    location = var.region_id

    github {
        name = "myui"
        owner = "nvd11"
        push {
            branch = "main"
            invert_regex = false # means trigger on the specified branch
        }
    }

    filename = "cloudbuild-cloudrun.yaml"
    service_account = data.google_service_account.cloudbuild_sa.id
}

