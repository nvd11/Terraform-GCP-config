terraform {
  backend "gcs" {
    bucket  = "divine-cortex-391518-terraform"
    prefix  = "terraform/state"
  }
}
