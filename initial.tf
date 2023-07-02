provider "google" {
    credentials = file("/opt/apps/terraform/gcpkey.json")
    project = "divine-cortex-391518"
    region = "asia-east1"
    zone = "asia-east1-a"
}