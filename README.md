#Terraform-GCP-config

WE can use below 2 env variables to define the service account

```shell
export GOOGLE_CLOUD_KEYFILE_JSON="/opt/apps/terraform/gcpkey.json"                   # for terraform itself
export GOOGLE_APPLICATION_CREDENTIALS="/opt/apps/terraform/gcpkey.json"              # for gcloud ,  terraform rely on gcloud for GCS
```